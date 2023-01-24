import express from "express";
import * as http from "https";
import * as dotenv from "dotenv";
import { Server } from "ws";
import { env } from "process";
import moment from 'moment';

dotenv.config();
const app = express()
  .use((req, res) => res.send("hi there"))
  .listen(process.env.PORT, () => console.log("port lisenting on "+ process.env.PORT));

const wss = new Server({ port:6060 });

var  webSockets: any = {}

wss.on('connection', function(ws, req) {
    var userID = req.url!.substr(1) //get userid from URL/userid 
    webSockets[userID] = ws //add new user to the connection list
    console.log('User connected:'+ userID)
    ws.on('message', message => {
        console.log(message);
        
        var datastring = message.toString();
        if(datastring.charAt(0) == "{"){ // Check if message starts with '{' to check if it's json
            datastring = datastring.replace(/\'/g, '"');
            var data = JSON.parse(datastring)
            if(data.auth == "chatapphdfgjd34534hjdfk"){
                if(data.cmd == 'send'){ 
                    var boardws = webSockets[data.userid] //check if there is reciever connection
                    if (boardws){
                        var cdata = "{'cmd':'" + data.cmd + "','userid':'"+data.userid+"', 'msgtext':'"+data.msgtext+"'}";
                        boardws.send(cdata); //send message to reciever
                        ws.send(data.cmd + ":success");
                    }else{
                        console.log("No reciever user found.");
                        ws.send(data.cmd + ":error");
                    }
                }else{
                    console.log("No send command");
                    ws.send(data.cmd + ":error");
                }
            }else{
                console.log("App Authincation error");
                ws.send(data.cmd + ":error");
            }
        }
    })
    ws.on('close', function () {
        var userID = req.url!.substr(1)
        delete webSockets[userID] //on connection close, remove reciver from connection list
        console.log('User Disconnected: ' + userID)
    })
    
    ws.send('connected');
})
