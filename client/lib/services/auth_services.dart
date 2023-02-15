import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/constance/constant_variebles.dart';
import 'package:client/constance/http_error_handler.dart';
import 'package:client/models/user_model.dart';
import 'package:client/pages/chat/chat_view.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:client/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../local_database/message_schema.dart';
import '../routes/router.gr.dart';

class AuthServices {
  void registerUser({
    required BuildContext context,
    required String email,
    required String username,
    required String password,
  }) async {
    http.Response response = await http.post(
      Uri.parse('$uri/auth/sign-up'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': '',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
      }),
    );
    if (context.mounted) {
      httpErrorHandler(
        context: context,
        response: response,
        onSuccess: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', jsonDecode(response.body)['token']);
          var user = User.fromMap(jsonDecode(response.body)['user']);
          if (context.mounted) {
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            context.router.pushAndPopUntil(
              const HomeRoute(),
              predicate: (route) => false,
            );
          }
        },
      );
    }
  }

  void login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    http.Response response = await http.post(
      Uri.parse('$uri/auth/sign-in'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': '',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    if (context.mounted) {
      httpErrorHandler(
        context: context,
        response: response,
        onSuccess: () async {
          var user = User.fromMap(jsonDecode(response.body)['user']);
          List<dynamic> messages =
              jsonDecode(response.body)['user']['messages'];
          late AppDatabase database =
              Provider.of<AppDatabase>(context, listen: false);
          for (var message in messages) {
            MessageData msgData = MessageData(
                sender: message['senderId'],
                isread: message['isRead'],
                time: DateTime.parse(message['createdAt']),
                isme: false,
                msgtext: message['msgText']);
            Provider.of<Unread>(context, listen: false).addMessages(msgData);
            await database
                .into(database.messages)
                .insert(MessagesCompanion.insert(
                  senderId: msgData.sender,
                  receiverId: user.username,
                  content: msgData.msgtext,
                  isRead: msgData.isread,
                  time: msgData.time,
                ));
          }
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', jsonDecode(response.body)['token']);
          if (context.mounted) {
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            context.router.pushAndPopUntil(
              const HomeRoute(),
              predicate: (route) => false,
            );
          }
        },
      );
    }
  }

  void authenticationByToken({required BuildContext context}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      log(token);
      http.Response response = await http.get(
        Uri.parse('$uri/auth/token'),
        headers: <String, String>{
          'content-type': 'application/json; charset=utf-8',
          'x-auth-token': token,
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandler(
        context: context,
        response: response,
        onSuccess: () async {
          var decodedJson = jsonDecode(response.body);
          List<dynamic> messages = decodedJson['messages'];
          late AppDatabase database =
              Provider.of<AppDatabase>(context, listen: false);
          var user = User.fromJson(response.body);
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          for (var message in messages) {
            MessageData msgData = MessageData(
                sender: message['senderId'],
                isread: message['isRead'],
                time: DateTime.parse(message['createdAt']),
                isme: false,
                msgtext: message['msgText']);
            Provider.of<Unread>(context, listen: false).addMessages(msgData);
            await database
                .into(database.messages)
                .insert(MessagesCompanion.insert(
                  senderId: msgData.sender,
                  receiverId: user.username,
                  content: msgData.msgtext,
                  isRead: msgData.isread,
                  time: msgData.time,
                ));
          }

          context.router.pushAndPopUntil(
            const HomeRoute(),
            predicate: (route) => false,
          );
        },
      );
    }
  }
}
