import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

class WsProvider extends ChangeNotifier {
  final StreamController<String> _streamController =
      StreamController.broadcast();
  StreamController<String> get streamController => _streamController;
  // Stream<List<String>> get stream => _messagesController.stream;
  List<dynamic> _online_users = [];
  List<dynamic> get onlineUsers => _online_users;
  void updateOnlineUsers(List<dynamic> availibleUsers) {
    _online_users = availibleUsers;
    notifyListeners();
  }
}
