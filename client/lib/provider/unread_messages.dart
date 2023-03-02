import 'package:flutter/material.dart';

import '../models/message_model.dart';

class Unread extends ChangeNotifier {
  final List<MessageModel> _messages = [];
  final String _currentChat = "";
  String get currentChat => _currentChat;
  set setChat(String chetter) => _currentChat;
  List<MessageModel> get messages => _messages;
  void addMessages(MessageModel message) {
    _messages.add(message);
    notifyListeners();
  }

  void readMessagesOf(String username) {
    _messages.removeWhere((element) => element.sender == username);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  int numberOfUnreadMessOf(String username) {
    int count = 0;
    for (var message in _messages) {
      if (message.sender == username) {
        count++;
      }
    }
    return count;
  }
}
