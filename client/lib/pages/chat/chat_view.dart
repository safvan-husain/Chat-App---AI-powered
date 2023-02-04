// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:client/provider/stream_provider.dart';
import 'package:client/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/io.dart';

import 'package:client/pages/chat/chat_view_model.dart';

class ChatPage extends StatefulWidget {
  IOWebSocketChannel channel;
  String recieverid;
  ChatPage({
    Key? key,
    required this.channel,
    required this.recieverid,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IOWebSocketChannel channel =
      widget.channel; //channel varaible for websocket
  late bool connected; // boolean value to track connection status

  String auth = "chatapphdfgjd34534hjdfk"; //auth key

  List<MessageData> msglist = [];

  TextEditingController msgtext = TextEditingController();

  @override
  void initState() {
    msgtext.text = "";
    listenToMessages();
    // channelconnect();
    super.initState();
  }

  void listenToMessages() {
    late StreamController<String> streamController =
        Provider.of<WsProvider>(context, listen: false).streamController;
    try {
      streamController.stream.listen((event) {
        log(event);
        if (event.substring(0, 6) == '{"cmd"') {
          print("Message data anallo");
          event = event.replaceAll(RegExp("'"), '"');
          var jsondata = json.decode(event);
          print(jsondata);
          log(jsondata["senderId"] + "==" + widget.recieverid);
          if (jsondata["senderId"] == widget.recieverid) {
            msglist.add(MessageData(
              //on event recieve, add data to model
              msgtext: jsondata["msgtext"],
              sender: jsondata["senderId"],
              isme: false,
            ));
            // if (mounted) return;
            setState(() {});
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  late String myId = context.read<UserProvider>().user.username;

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
        return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(" ${widget.recieverid} "),
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
                          const Text("Your Messages",
                              style: TextStyle(fontSize: 20)),
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
                                            Text(onemsg.isme
                                                ? "ID: ME"
                                                : "ID: ${onemsg.sender}"),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Text(
                                                  "Message: ${onemsg.msgtext}",
                                                  style: const TextStyle(
                                                      fontSize: 17)),
                                            ),
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
                                        widget
                                            .recieverid); //send message with websocket
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
  bool isme;
  MessageData({
    required this.msgtext,
    required this.sender,
    required this.isme,
  });
}
