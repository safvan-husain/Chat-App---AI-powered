import 'dart:developer';

import 'package:client/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late User _user;
  User get user => _user;
  void setUser(User user) {
    _user = user;
    log(_user.username);
    notifyListeners();
  }
}
