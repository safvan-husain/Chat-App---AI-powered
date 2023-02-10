import express from "express";
// import * as http from "https";
import * as dotenv from "dotenv";
import * as websocket from "ws";
import moment from "moment";
import { SigninRouter } from "./routes/sign_in_route";
import bodyParser, { json } from "body-parser";
import { SignUpRouter } from "./routes/sign_up_route";
import mongoose, { ConnectOptions } from "mongoose";
import cors from "cors";
import { DataRouter } from "./routes/get_data";
import { connect } from "http2";
import { onWebSocket } from "./utils/web_socket";

dotenv.config();
const app = express();

app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(express.json());
app.use(SigninRouter);
app.use(SignUpRouter);
app.use(DataRouter);

app.get("/", (req, res) => {
  res.send("privacy policy");
});

mongoose.set("strictQuery", true);
mongoose.connect(process.env.MongoUrl!, () => {
  console.log("MongoDB connected!");
});

const server = app.listen(process.env.PORT, () =>
  console.log("port lisenting on " + process.env.PORT)
);

const wss = new websocket.Server({ server });
onWebSocket(wss);

