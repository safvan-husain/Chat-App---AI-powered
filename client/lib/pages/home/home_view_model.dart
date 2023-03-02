import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../routes/router.gr.dart';
import '../../services/web_socket_set_up.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this.context);

  final BuildContext context;

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
}
