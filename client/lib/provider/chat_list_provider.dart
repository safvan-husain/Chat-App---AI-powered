// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:client/local_database/chat_list_local.dart';
import 'package:client/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatListProvider extends ChangeNotifier {
  List<User> _chat_list = [];
  List<User> get chat_list => _chat_list;
  void setList(List<User> list) async {
    if (_chat_list.isEmpty) {
      List<String>? users = await readChatList();
      if (users != null) {
        for (String userId in users) {
          for (User user in list) {
            if (userId == user.id) {
              _chat_list.add(user);
            }
          }
        }
      } else {
        _chat_list = list;
      }
    }
    for (User user in list) {
      for (User _user in _chat_list) {
        if (user.id == _user.id) {
          _user = user;
        }
      }
    }
    // _chat_list = list;
    notifyListeners();
  }

  void toTheTop(User user) {
    _chat_list.remove(user);
    storeChatList(_chat_list);
    storeChatList(_chat_list);
    notifyListeners();
  }

  void toTheTopFromUsername(String username) {
    for (User user in _chat_list) {
      if (user.username == username) {
        _chat_list.remove(user);
        _chat_list.insert(0, user);
      }
    }
    storeChatList(_chat_list);
    notifyListeners();
  }
}
