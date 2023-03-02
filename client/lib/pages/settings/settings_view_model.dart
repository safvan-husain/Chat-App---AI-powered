import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../routes/router.gr.dart';

class SettingsViewModel extends BaseViewModel {
  SettingsViewModel(this.context);

  final BuildContext context;
  void logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');
    if (context.mounted) {}
    context.router.pushAndPopUntil(
      const GoogleSignInRoute(),
      predicate: (route) => false,
    );
  }
}
