import 'package:flutter/material.dart';

import '../chat_view.dart';
import '../chat_view_model.dart';

class InputArea extends StatelessWidget {
  const InputArea({
    super.key,
    required this.widget,
    required this.viewModel,
  });

  final ChatPage widget;
  final ChatViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              decoration: const InputDecoration(hintText: "Enter your Message"),
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
            ),
          )
        ],
      ),
    );
  }
}
