import 'dart:convert';
import 'dart:math';
import 'package:client/constance/constant_variebles.dart';
import 'package:client/constance/http_error_handler.dart';
import 'package:client/models/user_model.dart';
import 'package:client/provider/chat_list_provider.dart';
import 'package:client/utils/get_token_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class GetDataService {
  Future<void> allUsers({
    required BuildContext context,
  }) async {
    List<User> users = [];
    var token = await getTokenFromStorage();
    if (token == null) return;
    http.Response response = await http.get(
      Uri.parse('$uri/get-data/all-user'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': token,
      },
    );
    if (context.mounted) {
      httpErrorHandler(
        context: context,
        response: response,
        onSuccess: () {
          var userList = jsonDecode(response.body);
          for (var i = 0; i < userList.length; i++) {
            var user = User.fromMap(userList.elementAt(i));
            users.add(user);
          }
          Provider.of<ChatListProvider>(context, listen: false).setList(users);
        },
      );
    }
    return;
  }
}
