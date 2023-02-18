import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../local_database/message_schema.dart';
import '../../provider/user_provider.dart';
import '../../routes/router.gr.dart';
import '../../services/web_socket_set_up.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this.context);

  final BuildContext context;

  String auth = "chatapphdfgjd34534hjdfk"; //auth key
  void logOut() async {
    channel.sink.close();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');
    if (context.mounted) {}
    context.router.pushAndPopUntil(
      const SignInRoute(),
      predicate: (route) => false,
    );
  }

  // void readAllMessagesFromStorage() async {
  //   late AppDatabase database =
  //       Provider.of<AppDatabase>(context, listen: false);
  //   allMessages = await database.select(database.messages).get();
  // }

  void checkAvailableUsers() {
    if (context.read<UserProvider>().user.isOnline == true) {
      channel.sink.add(jsonEncode({"auth": auth, "cmd": 'available_users'}));
    } else {
      channelconnect(context);
    }
  }
}
