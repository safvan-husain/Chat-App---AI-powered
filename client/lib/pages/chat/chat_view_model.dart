// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:client/models/user_model.dart';
import 'package:client/provider/chat_list_provider.dart';
import 'package:client/services/ai_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:drift/drift.dart' as drift;
import '../../local_database/message_schema.dart';
import '../../provider/stream_provider.dart';
import '../../provider/user_provider.dart';
import '../../services/web_socket_set_up.dart';
import 'chat_view.dart';

class ChatViewModel extends BaseViewModel {
  ChatViewModel(this.context, this.setState, this.widget);

  final BuildContext context;
  final VoidCallback setState;
  final ChatPage widget;
  List<MessageData> msglist = [];
  late AppDatabase database = Provider.of<AppDatabase>(context, listen: false);
  TextEditingController msgtext = TextEditingController();
  late User user = context.read<UserProvider>().user;
  var auth = "chatapphdfgjd34534hjdfk"; //auth key

  Future<void> sendmsgToAi() async {
    String prompt = "";
    Provider.of<ChatListProvider>(context, listen: false)
        .toTheTopFromUsername("Rajappan");
    msglist.add(MessageData(
      sender: user.id,
      isread: false,
      time: DateTime.now().toLocal(),
      isme: true,
      msgtext: msgtext.text,
    ));
    msgtext.text = '';
    setState();
    for (MessageData msg in msglist) {
      var sub_prompt = "";
      if (msg.isme) {
        sub_prompt = "me: ${msg.msgtext}\n";
        prompt = prompt + sub_prompt;
      } else {
        sub_prompt = "AI_Rajappan: ${msg.msgtext}\n";
        prompt = prompt + sub_prompt;
      }
    }
    var reply = await AiService().sendMessage(context: context, text: prompt);
    msglist.add(MessageData(
      sender: 'user',
      isread: false,
      time: DateTime.now().toLocal(),
      isme: false,
      msgtext: reply,
    ));
    setState();
  }

  Future<void> sendmsg(String sendmsg, String id) async {
    if (context.read<UserProvider>().user.isOnline == true) {
      Provider.of<ChatListProvider>(context, listen: false)
          .toTheTopFromUsername(id);
      await database.into(database.messages).insert(
            MessagesCompanion.insert(
              content: sendmsg,
              senderId: user.username,
              receiverId: id,
              isRead: false,
              time: DateTime.now(),
            ),
          );
      Map<dynamic, dynamic> msg = {
        "auth": auth,
        "cmd": 'send',
        "receiverId": id,
        "senderId": user.username,
        "msgtext": sendmsg
      };
      msgtext.text = "";
      msglist.add(MessageData(
        msgtext: sendmsg,
        sender: user.id,
        isme: true,
        isread: false,
        time: DateTime.now(),
      ));
      setState();
      sendEventToWebSocket(jsonEncode(msg));
    } else {
      channelconnect(context);
      print("Websocket is not connected.");
    }
  }

  void loadMessageFromLocalStorage(List<Message> allmessages) async {
    late String myId = context.read<UserProvider>().user.username;
    late AppDatabase database =
        Provider.of<AppDatabase>(context, listen: false);
    // final allMessages = await database.select(database.messages).get();

    for (var message in allmessages) {
      if (message.senderId == widget.user.username) {
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
          message.receiverId == widget.user.username) {
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
    Future.delayed(Duration.zero, () async {
      setState();
    });
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
          if (jsondata["senderId"] == widget.user.username) {
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
