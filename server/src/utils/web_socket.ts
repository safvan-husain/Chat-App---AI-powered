import * as websocket from "ws";
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
          JSON.stringify({ connected_devices: conected_devices })
        );
      }
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
              var cdata =
                "{'cmd':'" +
                data.cmd +
                "','receiverId':'" +
                data.receiverId +
                "', 'senderId':'" +
                data.senderId +
                "', 'msgtext':'" +
                data.msgtext +
                "'}";
              boardws.send(cdata); //send message to reciever
              cdata =
                "{'suc':'" +
                "success:send" +
                "','receiverId':'" +
                data.receiverId +
                "', 'senderId':'" +
                data.senderId +
                "', 'msgtext':'" +
                data.msgtext +
                "'}";
              ws.send(cdata);
            } else {
              console.log("No reciever user found.");
              ws.send(data.cmd + ":error");
            }
          } else if (data.cmd == "available_users") {
            console.log("called available users");

            ws.send(JSON.stringify({ connected_devices: conected_devices }));
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
      var index = conected_devices.indexOf(userID);
      if (index > -1) {
        conected_devices.splice(index, 1);
      }
      console.log(conected_devices);
      for (const userID in webSockets) {
        //sending to every client in the network
        webSockets[userID].send(
          JSON.stringify({ connected_devices: conected_devices })
        );
      }
    });

    ws.send("connected");
  });
}
