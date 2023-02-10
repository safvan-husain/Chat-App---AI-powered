// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:client/local_database/message_services.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:client/pages/chat/chat_view_model.dart';
import 'package:client/provider/user_provider.dart';

class ChatPage extends StatefulWidget {
  String senderId;
  ChatPage({
    Key? key,
    required this.senderId,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late bool isThisFirstCall;
  @override
  void initState() {
    isThisFirstCall = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      builder: (context, viewModel, child) {
        Provider.of<Unread>(context, listen: false)
            .readMessagesOf(widget.senderId);
        if (isThisFirstCall) {
          viewModel.msgtext.text = "";
          viewModel.loadMessageFromLocalStorage();
          viewModel.listenToMessages();
          isThisFirstCall = false;
        }
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
              actions: [
                ElevatedButton(
                  onPressed: () {
                    deleteChatOf(widget.senderId, context);
                    viewModel.msglist = [];
                    setState(() {});
                    // log('deleteChatOf');
                  },
                  child: const Text('delete'),
                )
              ],
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
                            children: viewModel.msglist.map((onemsg) {
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
                              controller: viewModel.msgtext,
                              decoration: const InputDecoration(
                                  hintText: "Enter your Message"),
                            ),
                          )),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                child: const Icon(Icons.send),
                                onPressed: () {
                                  if (viewModel.msgtext.text != "") {
                                    viewModel.sendmsg(
                                      viewModel.msgtext.text,
                                      widget.senderId,
                                    ); //send message with websocket
                                  }
                                },
                              ))
                        ],
                      )),
                )
              ],
            ));
      },
      viewModelBuilder: () => ChatViewModel(
        context,
        () {
          if (mounted) setState(() {});
        },
        widget,
      ),
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
