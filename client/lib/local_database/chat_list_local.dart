import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

//these functions are helping to list user chats according to the last message recieved

void storeChatList(List<User> userList) async {
  List<String> list = [];
  SharedPreferences preferences = await SharedPreferences.getInstance();
  for (User user in userList) {
    list.add(user.id);
  }
  preferences.setStringList('userList', list);
}

Future<List<String>?> readChatList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getStringList('userList');
}
