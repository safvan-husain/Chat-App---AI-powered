import 'package:auto_route/auto_route.dart';
import 'package:client/local_database/message_schema.dart';
import 'package:client/models/user_model.dart';
import 'package:client/pages/home/components/user_tile.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';

class UserWrapper extends StatelessWidget {
  const UserWrapper({
    Key? key,
    required this.index,
    required this.userList,
    required this.allMessages,
  }) : super(key: key);

  final int index;
  final List<User> userList;
  final List<Message> allMessages;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: (index == 0)
                  ? BorderSide(color: Theme.of(context).dividerColor)
                  : BorderSide.none,
              bottom: BorderSide(color: Theme.of(context).dividerColor))),
      child: InkWell(
        onTap: () {
          context.router.push(
            ChatRoute(
              user: userList[index],
              allmessages: allMessages,
            ),
          );
        },
        child: UserTile(user: userList[index]),
      ),
    );
  }
}
