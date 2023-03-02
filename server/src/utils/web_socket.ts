import * as websocket from "ws";
import { Message } from "../model/message_model";
import UserModel from "../model/user_model";
import { sendMessage } from "./push_notification";

export function onWebSocket(wss: websocket.Server<websocket.WebSocket>) {
  var webSockets: any = {};
  var conected_devices: string[] = [];

  wss.on("connection", function (ws, req) {
    var userID = req.url!.substr(1); //get userid from URL/userid
    webSockets[userID] = ws; //add new user to the connection list
    if (!conected_devices.includes(userID)) {
      conected_devices.push(userID);
      console.log(conected_devices);
      for (const userID in webSockets) {
        //sending to every client in the network
        webSockets[userID].send(
          JSON.stringify({
            cmd: "connected_devices",
            connected_devices: conected_devices,
          })
        );
      }
    }
    ws.on("message", async (message) => {
      var datastring = message.toString();
      if (datastring.charAt(0) == "{") {
        datastring = datastring.replace(/\'/g, '"');
        var data = JSON.parse(datastring);
        if (data.auth == "chatapphdfgjd34534hjdfk") {
          if (data.cmd == "send") {
            var reciever = webSockets[data.receiverId]; //check if there is reciever connection
            sendMessage({ title: `Message from ${data.senderId}`, body:data.msgtext,username: data.receiverId})
            if (reciever) {
              var cdata = JSON.stringify({
                cmd: 'listen',
                receiverId: data.receiverId,
                senderId: data.senderId,
                msgtext: data.msgtext,
              });
              reciever.send(cdata); //send message to reciever

              ws.send(
                JSON.stringify({
                  cmd: "success:send",
                  receiverId: data.receiverId,
                  senderId: data.senderId,
                  msgtext: data.msgtext,
                })
              );
            } else {
              try {
                let user = await UserModel.findOne({
                  username: data.receiverId,
                });
                if (user) {
                  console.log(data.receiverId + data.senderId);
                  
                  var msg = new Message({
                    senderId: data.senderId,
                    receiverId: data.receiverId,
                    msgText: data.msgtext,
                    isRead: false,
                  });
                  console.log(msg);
                  
                  user.messages.push(msg);
                 user = await user.save();
                //  console.log(user.messages);
                 
                }
              } catch (error) {
                console.log(error);
                
              }
              console.log("No reciever user found.");
              ws.send(JSON.stringify({ cmd: "send:error",msg: 'user is offline' }));
            }
          } else if (data.cmd == "available_users") {
            console.log("called available users");

            ws.send(
              JSON.stringify({
                cmd: "connected_devices",
                connected_devices: conected_devices,
              })
            );
          } else {
            console.log("No send command");
            ws.send(JSON.stringify({ cmd: "error" }));
          }
        } else {
          console.log("App Authincation error");
          ws.send(
            JSON.stringify({ cmd: "error", msg: "App Authincation error" })
          );
        }
      }
    });
    ws.on("close", function () {
      var userID = req.url!.substr(1);
      delete webSockets[userID]; //on connection close, remove reciver from connection list
      console.log("User Disconnected: " + userID);
      var index = conected_devices.indexOf(userID);
      if (index > -1) {
        conected_devices.splice(index, 1);
      }
      console.log(conected_devices);
      for (const userID in webSockets) {
        //sending to every client in the network
        webSockets[userID].send(
          JSON.stringify({
            cmd: "connected_devices",
            connected_devices: conected_devices,
          })
        );
      }
    });

    ws.send(JSON.stringify({ cmd: "connected" }));
  });
}
