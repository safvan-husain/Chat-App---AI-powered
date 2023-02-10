import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:client/constance/snack_bar.dart';
import 'package:client/local_database/message_schema.dart';
import 'package:client/pages/home/home_view.dart';
import 'package:client/provider/stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../constance/constant_variebles.dart';
import '../pages/chat/chat_view.dart';
import '../provider/unread_messages.dart';
import '../provider/user_provider.dart';

late IOWebSocketChannel channel;

channelconnect(BuildContext context) {
  late StreamController<String> streamController =
      Provider.of<WsProvider>(context, listen: false).streamController;
  var myid = context.read<UserProvider>().user.username;
  late AppDatabase database = Provider.of<AppDatabase>(context, listen: false);
  try {
    channel = IOWebSocketChannel.connect(
        "ws://$ipAddress:3000/$myid"); //channel IP : Port
    channel.stream.listen(
      (message) async {
        if (message == "connected") {
          Provider.of<UserProvider>(context, listen: false).setIsOnline(true);
        } else if (message.substring(0, 6) == "{'suc'") {
          message = message.replaceAll(RegExp("'"), '"');
          var jsondata = json.decode(message);
          if (jsondata["senderId"] != null && jsondata['receiverId'] != null) {
            await database.into(database.messages).insert(
                  MessagesCompanion.insert(
                    content: jsondata["msgtext"],
                    senderId: jsondata["senderId"],
                    receiverId: jsondata['receiverId'],
                    isRead: false,
                    time: DateTime.now(),
                  ),
                );
          } else {
            log('sender or reciever null');
          }
          if (HomePageState().mounted) HomePageState().setState(() {});
        } else if (message == "send:error") {
          showSnackBar(context, message);
        } else if (message.substring(0, 6) == "{'cmd'") {
          message = message.replaceAll(RegExp("'"), '"');
          var jsondata = json.decode(message);
          if (jsondata['receiverId'] == myid) {
            streamController.add(message);
            Provider.of<Unread>(context, listen: false).addMessages(
              MessageData(
                sender: jsondata["senderId"],
                isread: false,
                time: DateTime.now(),
                isme: false,
                msgtext: jsondata["msgtext"],
              ),
            );
            if (jsondata["senderId"] != null &&
                jsondata['receiverId'] != null) {
              await database.into(database.messages).insert(
                    MessagesCompanion.insert(
                      content: jsondata["msgtext"],
                      senderId: jsondata["senderId"],
                      receiverId: jsondata['receiverId'],
                      isRead: false,
                      time: DateTime.now(),
                    ),
                  );
            } else {
              log('sender or reciever null');
            }
          }
        } else if (message.substring(0, 6) == '{"conn') {
          message = message.replaceAll(RegExp("'"), '"');
          var jsondata = json.decode(message);
          Provider.of<WsProvider>(context, listen: false)
              .updateOnlineUsers(jsondata["connected_devices"]);
        }
        if (HomePageState().mounted) HomePageState().setState(() {});
        // setState(() {});
      },
      onDone: () {
        //if WebSocket is disconnected
        showSnackBar(context, "Web socket is closed");
        Provider.of<UserProvider>(context, listen: false).setIsOnline(false);
        if (HomePageState().mounted) HomePageState().setState(() {});
      },
      onError: (error) {
        print(error.toString());
      },
    );
  } catch (_) {
    print(_);
    showSnackBar(context, "error on connecting to websocket.");
  }
}

void sendEventToWebSocket(String msg) {
  channel.sink.add(msg); //send event to reciever channel
}
