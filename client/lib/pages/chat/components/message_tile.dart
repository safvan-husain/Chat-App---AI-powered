import 'package:client/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  final MessageModel onemsg;
  const MessageTile({
    Key? key,
    required this.onemsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          //if is my message, then it has margin 40 at left
          left: onemsg.isme ? 40 : 0,
          right: onemsg.isme ? 0 : 40, //else margin at right
        ),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: onemsg.isme ? Colors.blue[100] : Colors.red[100],
            //if its my message then, blue background else red background
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(onemsg.msgtext,
                        style: const TextStyle(fontSize: 17)),
                  ),
                  Text(DateFormat.jm().format(onemsg.time),
                      style: const TextStyle(fontSize: 10)),
                ],
              ),
            )));
  }
}
