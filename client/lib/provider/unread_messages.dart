import 'package:client/pages/chat/chat_view.dart';
import 'package:flutter/material.dart';

class Unread extends ChangeNotifier {
  final List<MessageData> _messages = [];

  List<MessageData> get messages => _messages;

  void addMessages(MessageData message) {
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
