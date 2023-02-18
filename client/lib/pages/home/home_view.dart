import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/pages/home/components/user_tile.dart';
import 'package:client/pages/home/home_view_model.dart';
import 'package:client/provider/chat_list_provider.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/get_data_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/io.dart';
import '../../local_database/message_schema.dart';
import '../../models/user_model.dart';
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

  @override
  void initState() {
    getAllUsers(context);
    channelconnect(context);

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
          appBar: _buildAppBar(context),
          body: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  context.router.push(
                    ChatRoute(
                      user: userList[index],
                      allmessages: allMessages,
                    ),
                  );
                },
                child: UserTile(user: userList[index]),
              );
            },
          ),
        );
      },
    );
  }
}

_buildAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size(double.infinity, 40),
    child: AppBar(
      title: const Text(
        "Messenger",
        style: TextStyle(color: Colors.blueGrey),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      actionsIconTheme: const IconThemeData(color: Colors.blueGrey),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
          ),
          onPressed: () {
            // do something
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.settings,
          ),
          onPressed: () {
            context.router.push(SettingsRoute());
          },
        )
      ],
    ),
  );
}
