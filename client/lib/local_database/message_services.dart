import 'package:client/local_database/message_schema.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void deleteChatOf(String username, BuildContext context) async {
  var database = Provider.of<AppDatabase>(context, listen: false);
  await (database.delete(database.messages)
        ..where((tbl) {
          return tbl.senderId.equals(username);
        }))
      .go();
  await (database.delete(database.messages)
        ..where((tbl) {
          return tbl.receiverId.equals(username);
        }))
      .go();
}
