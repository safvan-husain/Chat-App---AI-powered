// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:client/provider/unread_messages.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/io.dart';
import 'package:intl/intl.dart';
import 'package:client/local_database/message_schema.dart';
import 'package:client/pages/chat/chat_view_model.dart';
import 'package:client/provider/stream_provider.dart';
import 'package:client/provider/user_provider.dart';

class ChatPage extends StatefulWidget {
  IOWebSocketChannel channel;
  String senderId;
  ChatPage({
    Key? key,
    required this.channel,
    required this.senderId,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IOWebSocketChannel channel =
      widget.channel; //channel varaible for websocket
  late bool connected; // boolean value to track connection status
  var auth = "chatapphdfgjd34534hjdfk"; //auth key
  late AppDatabase database = Provider.of<AppDatabase>(context, listen: false);
  List<MessageData> msglist = [];

  TextEditingController msgtext = TextEditingController();

  @override
  void initState() {
    msgtext.text = "";
    listenToMessages();
    loadMessageFromLocalStorage();
    super.initState();
  }

  late String myId = context.read<UserProvider>().user.username;

  void loadMessageFromLocalStorage() async {
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
    setState(() {});
  }

  void listenToMessages() {
    Provider.of<Unread>(context, listen: false).readMessagesOf(widget.senderId);
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

            if (mounted) {
              setState(() {});
            }
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendmsg(String sendmsg, String id) async {
    if (context.read<UserProvider>().user.isOnline == true) {
      String msg =
          "{'auth':'$auth','cmd':'send','receiverId':'$id','senderId': '$myId', 'msgtext':'$sendmsg'}";
      setState(() {
        msgtext.text = "";
        msglist.add(MessageData(
          msgtext: sendmsg,
          sender: myId,
          isme: true,
          isread: false,
          time: DateTime.now(),
        ));
      });
      channel.sink.add(msg); //send event to reciever channel
    } else {
      // channelconnect();
      print("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ChatViewModel(),
      builder: (context, viewModel, child) {
        var column = Column;
        return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(" ${widget.senderId} "),
              leading: Icon(Icons.circle,
                  color: context.watch<UserProvider>().user.isOnline
                      ? Colors.greenAccent
                      : Colors.redAccent),
              //if app is connected to node.js then it will be gree, else red.
              titleSpacing: 0,
            ),
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 70,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Column(
                        children: [
                          Column(
                            children: msglist.map((onemsg) {
                              return Container(
                                  margin: EdgeInsets.only(
                                    //if is my message, then it has margin 40 at left
                                    left: onemsg.isme ? 40 : 0,
                                    right: onemsg.isme
                                        ? 0
                                        : 40, //else margin at right
                                  ),
                                  child: Card(
                                      color: onemsg.isme
                                          ? Colors.blue[100]
                                          : Colors.red[100],
                                      //if its my message then, blue background else red background
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Text(onemsg.msgtext,
                                                  style: const TextStyle(
                                                      fontSize: 17)),
                                            ),
                                            Text(DateFormat.jm()
                                                .format(onemsg.time)),
                                          ],
                                        ),
                                      )));
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  //position text field at bottom of screen

                  bottom: 0, left: 0, right: 0,
                  child: Container(
                      color: Colors.black12,
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextField(
                              controller: msgtext,
                              decoration: const InputDecoration(
                                  hintText: "Enter your Message"),
                            ),
                          )),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                child: const Icon(Icons.send),
                                onPressed: () {
                                  if (msgtext.text != "") {
                                    sendmsg(
                                      msgtext.text,
                                      widget.senderId,
                                    ); //send message with websocket
                                  } else {
                                    print("Enter message");
                                  }
                                },
                              ))
                        ],
                      )),
                )
              ],
            ));
      },
    );
  }
}

class MessageData {
  //message data model
  String msgtext, sender;
  bool isme, isread;
  DateTime time;
  MessageData({
    required this.sender,
    required this.isread,
    required this.time,
    required this.isme,
    required this.msgtext,
  });
}
