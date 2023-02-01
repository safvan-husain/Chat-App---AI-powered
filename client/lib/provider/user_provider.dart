// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:client/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late User _user;
  User get user => _user;
  void setUser(User user) {
    _user = user;
    log(_user.username);
    notifyListeners();
  }

  // UserProvider copyWith({
  //   bool? isOnline,
  // }) {
  //   return UserProvider(
  //     _user: _user ?? this._user,
  //   );
  // }
  void setIsOnline(bool isOnline) {
    _user.isOnline = isOnline;
    log(_user.isOnline.toString());
    notifyListeners();
  }
}
