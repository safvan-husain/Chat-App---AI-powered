import 'package:flutter/material.dart';

import '../chat_view_model.dart';
import 'message_tile.dart';

class ChatViewArea extends StatelessWidget {
  final ChatViewModel viewModel;
  const ChatViewArea({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: viewModel.msglist.map((onemsg) {
            if (onemsg.sender == 'Rajappan') {
              onemsg.msgtext = onemsg.msgtext.replaceAll("AI_Rajappan:", "");
            }
            return MessageTile(onemsg: onemsg);
          }).toList(),
        ),
      ),
    );
  }
}
