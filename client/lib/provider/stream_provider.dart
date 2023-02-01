import 'dart:async';

import 'package:flutter/cupertino.dart';

class ChatProvider extends ChangeNotifier {
  final StreamController<String> _streamController =
      StreamController.broadcast();
  StreamController<String> get streamController => _streamController;
  // Stream<List<String>> get stream => _messagesController.stream;
}
