import express from "express";
// import * as http from "https";
import * as dotenv from "dotenv";
import * as websocket from "ws";
import moment from "moment";
import { SigninRouter } from "./routes/sign_in_route";
import bodyParser from "body-parser";
import { SignUpRouter } from "./routes/sign_up_route";
import mongoose, { ConnectOptions } from "mongoose";
import cors from "cors";
import { DataRouter } from "./routes/get_data";


dotenv.config();
const app = express();

app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(express.json());
app.use(SigninRouter);
app.use(SignUpRouter);
app.use(DataRouter)

app.get('/', (req, res) => { res.send('privacy policy')})

mongoose.set('strictQuery', true);
mongoose.connect(process.env.MongoUrl!, () => {
  console.log("MongoDB connected!");
});

const server = app.listen(process.env.PORT, () =>
  console.log("port lisenting on " + process.env.PORT)
);

const wss = new websocket.Server({ server });

var webSockets: any = {};
var conected_devices: string[] = [];
wss.on("connection", function (ws, req) {
  var userID = req.url!.substr(1); //get userid from URL/userid
  // console.log(ws);
  conected_devices.push(userID);
  webSockets[userID] = ws; //add new user to the connection list
  // console.log("User connected:" + userID);
  console.log(conected_devices);
  
  // ws.send(JSON.stringify({ "conected_devices": webSockets}));
  ws.on("message", (message) => {
    console.log(message);

    var datastring = message.toString();
    if (datastring.charAt(0) == "{") {
      // Check if message starts with '{' to check if it's json
      datastring = datastring.replace(/\'/g, '"');
      var data = JSON.parse(datastring); 
      if (data.auth == "chatapphdfgjd34534hjdfk") {
        if (data.cmd == "send") {
          var boardws = webSockets[data.userid]; //check if there is reciever connection
          if (boardws) {
            var cdata =
              "{'cmd':'" +
              data.cmd +
              "','userid':'" +
              data.userid +
              "', 'msgtext':'" +
              data.msgtext +
              "'}";
            boardws.send(cdata); //send message to reciever
            ws.send(data.cmd + ":success");
          } else {
            console.log("No reciever user found.");
            ws.send(data.cmd + ":error");
          }
        } else {
          console.log("No send command");
          ws.send(data.cmd + ":error");
        }
      } else {
        console.log("App Authincation error");
        ws.send(data.cmd + ":error");
      }
    }
  });
  ws.on("close", function () {
    var userID = req.url!.substr(1);
    delete webSockets[userID]; //on connection close, remove reciver from connection list
    console.log("User Disconnected: " + userID);
    conected_devices.filter((e) => e !== userID);
    console.log(conected_devices);
    
  });

  ws.send("connected");
});
