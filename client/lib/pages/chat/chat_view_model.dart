import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:drift/drift.dart' as drift;
import '../../local_database/message_schema.dart';
import '../../provider/stream_provider.dart';
import '../../provider/unread_messages.dart';
import '../../provider/user_provider.dart';
import '../../services/web_socket_set_up.dart';
import 'chat_view.dart';

class ChatViewModel extends BaseViewModel {
  ChatViewModel(this.context, this.setState, this.widget);

  final BuildContext context;
  final VoidCallback setState;
  final dynamic widget;
  List<MessageData> msglist = [];

  TextEditingController msgtext = TextEditingController();
  late String myId = context.read<UserProvider>().user.username;
  var auth = "chatapphdfgjd34534hjdfk"; //auth key

  Future<void> sendmsg(String sendmsg, String id) async {
    if (context.read<UserProvider>().user.isOnline == true) {
      String msg =
          "{'auth':'$auth','cmd':'send','receiverId':'$id','senderId': '$myId', 'msgtext':'$sendmsg'}";
      msgtext.text = "";
      msglist.add(MessageData(
        msgtext: sendmsg,
        sender: myId,
        isme: true,
        isread: false,
        time: DateTime.now(),
      ));
      setState();
      sendEventToWebSocket(msg);
    } else {
      // channelconnect();
      print("Websocket is not connected.");
    }
  }

  void loadMessageFromLocalStorage() async {
    late String myId = context.read<UserProvider>().user.username;
    late AppDatabase database =
        Provider.of<AppDatabase>(context, listen: false);
    final allMessages = await database.select(database.messages).get();

    for (var message in allMessages) {
      if (message.senderId == widget.senderId) {
        msglist.add(
          MessageData(
            msgtext: message.content,
            sender: message.senderId,
            isme: false,
            isread: true,
            time: message.time,
          ),
        );
        (database.update(database.messages)
              ..where(
                (tbl) => tbl.id.equals(message.id),
              ))
            .write(
          const MessagesCompanion(
            isRead: drift.Value(true),
          ),
        );
      } else if (message.senderId == myId &&
          message.receiverId == widget.senderId) {
        msglist.add(
          MessageData(
            msgtext: message.content,
            sender: message.senderId,
            isme: true,
            isread: true,
            time: message.time,
          ),
        );
      }
    }
    setState();
  }

  void listenToMessages() {
    late StreamController<String> streamController =
        Provider.of<WsProvider>(context, listen: false).streamController;
    try {
      streamController.stream.listen((event) {
        // log(event);
        if (event.substring(0, 6) == '{"cmd"') {
          event = event.replaceAll(RegExp("'"), '"');
          var jsondata = json.decode(event);
          if (jsondata["senderId"] == widget.senderId) {
            msglist.add(
              MessageData(
                //on event recieve, add data to model
                msgtext: jsondata["msgtext"],
                sender: jsondata["senderId"],
                isme: false,
                isread: true,
                time: DateTime.now(),
              ),
            );
            setState();
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
