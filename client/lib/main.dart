import 'dart:developer';

import 'package:client/local_database/message_schema.dart';
import 'package:client/provider/chat_list_provider.dart';
import 'package:client/provider/stream_provider.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:client/provider/user_provider.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/push_notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constance/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WsProvider(),
        ),
        Provider(
          create: (_) => AppDatabase(),
        ),
        ChangeNotifierProvider(
          create: (_) => Unread(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat App',
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
