import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/constance/constant_variebles.dart';
import 'package:client/pages/chat/chat_view.dart';
import 'package:client/pages/home/home_view_model.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:client/provider/user_provider.dart';
import 'package:client/provider/stream_provider.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/get_data_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/io.dart';

import '../../local_database/message_schema.dart';
import '../../models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IOWebSocketChannel channel; //channel varaible for websocket
  late bool connected; // boolean value to track connection status

  late String myid;
  void getMyId() {
    myid = context.read<UserProvider>().user.username;
  }

  String auth = "chatapphdfgjd34534hjdfk"; //auth key

  TextEditingController msgtext = TextEditingController();
  List<User> accounts = [];
  GetDataService getData = GetDataService();
  late StreamController<String> streamController =
      Provider.of<WsProvider>(context, listen: false).streamController;
  late AppDatabase database = Provider.of<AppDatabase>(context, listen: false);
  void getAllUsers(BuildContext context) async {
    accounts = await getData.allUsers(context: context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMyId();
    getAllUsers(context);
    connected = false;
    msgtext.text = "";
    channelconnect();
  }

  void logOut() async {
    channel.sink.close();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');
    context.router.pushAndPopUntil(
      const SignInRoute(),
      predicate: (route) => false,
    );
  }

  void check_available_users() {
    if (context.read<UserProvider>().user.isOnline == true) {
      String msg = "{'auth':'$auth','cmd':'available_users'}";
      channel.sink.add(msg);
    } else {
      channelconnect();
    }
  }

  channelconnect() {
    try {
      channel = IOWebSocketChannel.connect(
          "ws://$ipAddress:3000/$myid"); //channel IP : Port
      channel.stream.listen(
        (message) async {
          // log(message);

          if (message == "connected") {
            connected = true;
            Provider.of<UserProvider>(context, listen: false).setIsOnline(true);
            setState(() {});
            // print("Connection establised.");
          } else if (message.substring(0, 6) == "{'suc'") {
            message = message.replaceAll(RegExp("'"), '"');
            var jsondata = json.decode(message);
            if (jsondata["senderId"] != null &&
                jsondata['receiverId'] != null) {
              await database.into(database.messages).insert(
                    MessagesCompanion.insert(
                      content: jsondata["msgtext"],
                      senderId: jsondata["senderId"],
                      receiverId: jsondata['receiverId'],
                      isRead: false,
                      time: DateTime.now(),
                    ),
                  );
            } else {
              log('sender or reciever null');
            }

            // print("Message send success");
            setState(() {
              msgtext.text = "";
            });
          } else if (message == "send:error") {
            // print("Message send error - what do i do?");
          } else if (message.substring(0, 6) == "{'cmd'") {
            // print("Message datathanne");

            message = message.replaceAll(RegExp("'"), '"');
            var jsondata = json.decode(message);
            if (jsondata['receiverId'] == myid) {
              streamController.add(message);
              Provider.of<Unread>(context, listen: false).addMessages(
                MessageData(
                  sender: jsondata["senderId"],
                  isread: false,
                  time: DateTime.now(),
                  isme: false,
                  msgtext: jsondata["msgtext"],
                ),
              );
              if (jsondata["senderId"] != null &&
                  jsondata['receiverId'] != null) {
                await database.into(database.messages).insert(
                      MessagesCompanion.insert(
                        content: jsondata["msgtext"],
                        senderId: jsondata["senderId"],
                        receiverId: jsondata['receiverId'],
                        isRead: false,
                        time: DateTime.now(),
                      ),
                    );
              } else {
                log('sender or reciever null');
              }
            }
          } else if (message.substring(0, 6) == '{"conn') {
            message = message.replaceAll(RegExp("'"), '"');
            var jsondata = json.decode(message);
            Provider.of<WsProvider>(context, listen: false)
                .updateOnlineUsers(jsondata["connected_devices"]);
          }
          setState(() {});
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          Provider.of<UserProvider>(context, listen: false).setIsOnline(false);
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print(_);
      print("error on connecting to websocket.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 40),
            child: AppBar(
              title: const Text(
                "Messenger",
                style: TextStyle(color: Colors.blueGrey),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              actions: [
                InkWell(
                  onTap: check_available_users,
                  child: Icon(Icons.circle,
                      color: context.watch<UserProvider>().user.isOnline
                          ? Colors.greenAccent
                          : Colors.redAccent),
                ),
                TextButton(
                  onPressed: logOut,
                  child: const Text('Log Out'),
                )
              ],
            ),
          ),
          body: ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  context.router.push(
                    ChatRoute(
                      senderId: accounts[index].username,
                      channel: channel,
                    ),
                  );
                },
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://lh3.googleusercontent.com/a/AEdFTp7Wst9_bZuIYK4TkKmkNSEDfozjlI6KggsPTfz3=s96-c-rg-br100'),
                  ),
                  title: Text(accounts[index].username),
                  trailing: Text(
                    Provider.of<Unread>(context)
                        .numberOfUnreadMessOf(accounts[index].username)
                        .toString(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
