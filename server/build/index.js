"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
// import * as http from "https";
const dotenv = __importStar(require("dotenv"));
const websocket = __importStar(require("ws"));
const sign_in_route_1 = require("./routes/sign_in_route");
const body_parser_1 = __importDefault(require("body-parser"));
const sign_up_route_1 = require("./routes/sign_up_route");
const mongoose_1 = __importDefault(require("mongoose"));
const cors_1 = __importDefault(require("cors"));
const get_data_1 = require("./routes/get_data");
dotenv.config();
const app = (0, express_1.default)();
app.use(body_parser_1.default.json());
app.use(express_1.default.urlencoded({ extended: true }));
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use(sign_in_route_1.SigninRouter);
app.use(sign_up_route_1.SignUpRouter);
app.use(get_data_1.DataRouter);
app.get('/', (req, res) => { res.send('privacy policy'); });
mongoose_1.default.set('strictQuery', true);
mongoose_1.default.connect(process.env.MongoUrl, () => {
    console.log("MongoDB connected!");
});
const server = app.listen(process.env.PORT, () => console.log("port lisenting on " + process.env.PORT)).on("error", function (err) {
    process.once("SIGUSR2", function () {
        process.kill(process.pid, "SIGUSR2");
    });
    process.on("SIGINT", function () {
        // this is only called on ctrl+c, not restart
        process.kill(process.pid, "SIGINT");
    });
});
const wss = new websocket.Server({ server });
var webSockets = {};
var conected_devices = [];
wss.on("connection", function (ws, req) {
    var userID = req.url.substr(1); //get userid from URL/userid
    webSockets[userID] = ws; //add new user to the connection list
    if (!conected_devices.includes(userID)) {
        conected_devices.push(userID);
        ws.send(JSON.stringify({ "connected_devices": conected_devices }));
        console.log(conected_devices);
    }
    ws.on("message", (message) => {
        var datastring = message.toString();
        if (datastring.charAt(0) == "{") {
            datastring = datastring.replace(/\'/g, '"');
            var data = JSON.parse(datastring);
            if (data.auth == "chatapphdfgjd34534hjdfk") {
                if (data.cmd == "send") {
                    var boardws = webSockets[data.receiverId]; //check if there is reciever connection
                    if (boardws) {
                        var cdata = "{'cmd':'" +
                            data.cmd +
                            "','receiverId':'" +
                            data.receiverId +
                            "', 'senderId':'" +
                            data.senderId +
                            "', 'msgtext':'" +
                            data.msgtext +
                            "'}";
                        boardws.send(cdata); //send message to reciever
                        ws.send(data.cmd + ":success");
                    }
                    else {
                        console.log("No reciever user found.");
                        ws.send(data.cmd + ":error");
                    }
                }
                else {
                    console.log("No send command");
                    ws.send(data.cmd + ":error");
                }
            }
            else {
                console.log("App Authincation error");
                ws.send(data.cmd + ":error");
            }
        }
    });
    ws.on("close", function () {
        var userID = req.url.substr(1);
        delete webSockets[userID]; //on connection close, remove reciver from connection list
        console.log("User Disconnected: " + userID);
        var index = conected_devices.indexOf(userID);
        if (index > -1) {
            conected_devices.splice(index, 1);
        }
        console.log(conected_devices);
        ws.send(JSON.stringify({ "connected_devices": conected_devices }));
    });
    ws.send("connected");
});
