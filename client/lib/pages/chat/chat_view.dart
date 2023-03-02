// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import 'package:client/local_database/message_schema.dart';
import 'package:client/local_database/message_services.dart';
import 'package:client/models/user_model.dart';
import 'package:client/pages/chat/chat_view_model.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:client/utils/show_avatar.dart';

import '../profile/avatar/svg_rapper.dart';
import 'components/chat_view_area.dart';
import 'components/input_area.dart';

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
  DrawableRoot? svgRoot;

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
    return WillPopScope(
      onWillPop: () async {
        Provider.of<Unread>(context, listen: false).setChat = "";
        return true;
      },
      child: ViewModelBuilder.reactive(
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
                  child: ChatViewArea(viewModel: viewModel),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InputArea(
                    widget: widget,
                    viewModel: viewModel,
                  ),
                )
              ],
            ),
          );
        },
        viewModelBuilder: () => ChatViewModel(
          context,
          () {
            if (mounted) setState(() {});
          },
          widget,
        ),
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
      elevation: 0,
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
