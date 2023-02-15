import 'dart:convert';

import 'package:client/constance/http_error_handler.dart';
import 'package:client/utils/get_token_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constance/constant_variebles.dart';

class AiService {
  String reply = '';
  Future<String> sendMessage({
    required BuildContext context,
    required String text,
  }) async {
    var token = await getTokenFromStorage();
    if (token == null) return 'Something is wrong';
    http.Response response = await http.post(
      Uri.parse('$uri/ai/generate'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': token,
      },
      body: jsonEncode({
        'message': text,
      }),
    );
    if (context.mounted) {}
    httpErrorHandler(
      context: context,
      response: response,
      onSuccess: () {
        reply = jsonDecode(response.body)['result'];
      },
    );
    return reply;
  }
}
