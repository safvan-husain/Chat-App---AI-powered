import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/pages/home/components/user_tile.dart';
import 'package:client/pages/home/home_view_model.dart';
import 'package:client/provider/chat_list_provider.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/get_data_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/io.dart';
import '../../local_database/message_schema.dart';
import '../../models/user_model.dart';
import '../../services/push_notification_services.dart';
import '../../services/web_socket_set_up.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late IOWebSocketChannel channel; //channel varaible for websocket
  List<Message> allMessages = [];
  List<User> userList = [];
  GetDataService getData = GetDataService();
  void getAllUsers(BuildContext context) async {
    await getData.allUsers(context: context);
    setState(() {});
  }

  void updateUserList(BuildContext context) {
    userList = Provider.of<ChatListProvider>(context).chat_list;
    // log(userList.length.toString());
    setState(() {});
  }

  void connectToWebsocket() {
    channelconnect(context);
  }

  @override
  void initState() {
    getAllUsers(context);
    connectToWebsocket();
    FirebaseMessaging.onMessage.listen((message) {
      log('onmsg');
      bool canIshow = true;
      (message.data.forEach((key, value) {
        if (key == "reciever") {
          if (value == context.read<Unread>().currentChat) {
            canIshow = false;
          }
        }
      }));
      if (canIshow) showFlutterNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    super.initState();
  }

  void readAllMessagesFromStorage() async {
    late AppDatabase database =
        Provider.of<AppDatabase>(context, listen: false);
    allMessages = await database.select(database.messages).get();
  }

  @override
  void didChangeDependencies() {
    updateUserList(context);
    readAllMessagesFromStorage();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(context),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: _buildAppBar(context, viewModel),
          body: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: (index == 0)
                            ? BorderSide(color: Theme.of(context).dividerColor)
                            : BorderSide.none,
                        bottom:
                            BorderSide(color: Theme.of(context).dividerColor))),
                child: InkWell(
                  onTap: () {
                    context.router.push(
                      ChatRoute(
                        user: userList[index],
                        allmessages: allMessages,
                      ),
                    );
                  },
                  child: UserTile(user: userList[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }

  _buildAppBar(BuildContext context, viewModel) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 40),
      child: AppBar(
        title: const Text(
          "Messenger",
          style: TextStyle(color: Colors.blueGrey),
        ),
        elevation: 0,
        actionsIconTheme: const IconThemeData(color: Colors.blueGrey),
        actions: [
          PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              itemBuilder: (ctx) => [
                    _buildPopupItem('search', () {}),
                    _buildPopupItem('settings', () {
                      context.router.push(SettingsRoute());
                    }),
                    _buildPopupItem('Log out', () async {
                      // channel.sink.close();
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('token', '');
                      if (context.mounted) {}
                      context.router.pushAndPopUntil(
                        const GoogleSignInRoute(),
                        predicate: (route) => false,
                      );
                    }),
                  ])
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupItem(String action, VoidCallback onTap) {
    return PopupMenuItem(
      onTap: onTap,
      child: Text(action),
    );
  }
}
