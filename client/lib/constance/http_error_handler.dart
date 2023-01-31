import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

void httpErrorHandler({
  required BuildContext context,
  required http.Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 401:
      log(response.body);
      break;
    default:
  }
}
