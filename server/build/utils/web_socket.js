"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.onWebSocket = void 0;
const message_model_1 = require("../model/message_model");
const user_model_1 = __importDefault(require("../model/user_model"));
function onWebSocket(wss) {
    var webSockets = {};
    var conected_devices = [];
    wss.on("connection", function (ws, req) {
        var userID = req.url.substr(1); //get userid from URL/userid
        webSockets[userID] = ws; //add new user to the connection list
        if (!conected_devices.includes(userID)) {
            conected_devices.push(userID);
            console.log(conected_devices);
            for (const userID in webSockets) {
                //sending to every client in the network
                webSockets[userID].send(JSON.stringify({
                    cmd: "connected_devices",
                    connected_devices: conected_devices,
                }));
            }
        }
        ws.on("message", (message) => __awaiter(this, void 0, void 0, function* () {
            var datastring = message.toString();
            if (datastring.charAt(0) == "{") {
                datastring = datastring.replace(/\'/g, '"');
                var data = JSON.parse(datastring);
                if (data.auth == "chatapphdfgjd34534hjdfk") {
                    if (data.cmd == "send") {
                        var reciever = webSockets[data.receiverId]; //check if there is reciever connection
                        if (reciever) {
                            var cdata = JSON.stringify({
                                cmd: 'listen',
                                receiverId: data.receiverId,
                                senderId: data.senderId,
                                msgtext: data.msgtext,
                            });
                            reciever.send(cdata); //send message to reciever
                            ws.send(JSON.stringify({
                                cmd: "success:send",
                                receiverId: data.receiverId,
                                senderId: data.senderId,
                                msgtext: data.msgtext,
                            }));
                        }
                        else {
                            try {
                                let user = yield user_model_1.default.findOne({
                                    username: data.receiverId,
                                });
                                if (user) {
                                    console.log(data.receiverId + data.senderId);
                                    var msg = new message_model_1.Message({
                                        senderId: data.senderId,
                                        receiverId: data.receiverId,
                                        msgText: data.msgtext,
                                        isRead: false,
                                    });
                                    console.log(msg);
                                    user.messages.push(msg);
                                    user = yield user.save();
                                    //  console.log(user.messages);
                                }
                            }
                            catch (error) {
                                console.log(error);
                            }
                            console.log("No reciever user found.");
                            ws.send(JSON.stringify({ cmd: "send:error", msg: 'user is offline' }));
                        }
                    }
                    else if (data.cmd == "available_users") {
                        console.log("called available users");
                        ws.send(JSON.stringify({
                            cmd: "connected_devices",
                            connected_devices: conected_devices,
                        }));
                    }
                    else {
                        console.log("No send command");
                        ws.send(JSON.stringify({ cmd: "error" }));
                    }
                }
                else {
                    console.log("App Authincation error");
                    ws.send(JSON.stringify({ cmd: "error", msg: "App Authincation error" }));
                }
            }
        }));
        ws.on("close", function () {
            var userID = req.url.substr(1);
            delete webSockets[userID]; //on connection close, remove reciver from connection list
            console.log("User Disconnected: " + userID);
            var index = conected_devices.indexOf(userID);
            if (index > -1) {
                conected_devices.splice(index, 1);
            }
            console.log(conected_devices);
            for (const userID in webSockets) {
                //sending to every client in the network
                webSockets[userID].send(JSON.stringify({
                    cmd: "connected_devices",
                    connected_devices: conected_devices,
                }));
            }
        });
        ws.send(JSON.stringify({ cmd: "connected" }));
    });
}
exports.onWebSocket = onWebSocket;
