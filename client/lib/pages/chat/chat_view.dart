// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:client/local_database/message_schema.dart';
import 'package:client/local_database/message_services.dart';
import 'package:client/models/user_model.dart';
import 'package:client/provider/stream_provider.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:client/utils/show_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:client/pages/chat/chat_view_model.dart';

import '../profile/avatar/svg_rapper.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final List<Message> allmessages;
  const ChatPage({
    Key? key,
    required this.user,
    required this.allmessages,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late bool isThisFirstCall;
  DrawableRoot? svgRoot = null;
  _generateSvg(String? svgCode) async {
    svgCode ??= multiavatar(widget.user.username);
    return SvgWrapper(svgCode).generateLogo().then((value) {
      setState(() {
        svgRoot = value!;
      });
    });
  }

  @override
  void initState() {
    isThisFirstCall = true;
    _generateSvg(widget.user.avatar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      builder: (context, viewModel, child) {
        Provider.of<Unread>(context, listen: false)
            .readMessagesOf(widget.user.username);
        if (isThisFirstCall) {
          viewModel.msgtext.text = "";
          viewModel.loadMessageFromLocalStorage(widget.allmessages);
          viewModel.listenToMessages();
          isThisFirstCall = false;
        }
        return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: _buildAppBar(viewModel),
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
                              if (onemsg.sender == 'Rajappan') {
                                onemsg.msgtext = onemsg.msgtext
                                    .replaceAll("AI_Rajappan:", "");
                              }
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
                              textInputAction: TextInputAction.send,
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
                                    if (widget.user.username == 'Rajappan') {
                                      viewModel.sendmsgToAi();
                                    } else {
                                      viewModel.sendmsg(
                                        viewModel.msgtext.text,
                                        widget.user.username,
                                      ); //send message with websocket
                                    }
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

  PopupMenuItem _buildPopupItem(String action, VoidCallback onTap) {
    return PopupMenuItem(
      onTap: onTap,
      child: Text(action),
    );
  }

  AppBar _buildAppBar(ChatViewModel viewModel) {
    return AppBar(
      elevation: 00,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Text(
            widget.user.username,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
      leading: svgRoot == null
          ? const CircleAvatar()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: showAvatar(svgRoot!, 0)),
      titleSpacing: 0,
      actions: [
        PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (ctx) => [
                  _buildPopupItem('clear chat', () {
                    viewModel.msglist.clear();
                    if (widget.user.username != 'Rajappan') {
                      deleteChatOf(widget.user.username, context);
                    }
                    setState(() {});
                  }),
                  _buildPopupItem('Block', () {}),
                ])
      ],
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
