import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:client/pages/home/home_view_model.dart';
import 'package:client/provider/user_provider.dart';
import 'package:client/provider/stream_provider.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/get_data_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/io.dart';

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

  //my id
  // String recieverid = "111"; //reciever id
  // swap myid and recieverid value on another mobile to test send and recieve
  String auth = "chatapphdfgjd34534hjdfk"; //auth key

  List<MessageData> msglist = [];

  TextEditingController msgtext = TextEditingController();
  List<User> accounts = [];
  GetDataService getData = GetDataService();
  late StreamController<String> streamController =
      Provider.of<ChatProvider>(context, listen: false).streamController;

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');
    context.router.pushAndPopUntil(
      const SignInRoute(),
      predicate: (route) => false,
    );
  }

  channelconnect() {
    //function to connect
    try {
      channel = IOWebSocketChannel.connect(
          "ws://192.168.173.149:3000/$myid"); //channel IP : Port
      channel.stream.listen(
        (message) {
          // print(message + "hello world");
          setState(() {
            if (message == "connected") {
              connected = true;
              Provider.of<UserProvider>(context, listen: false)
                  .setIsOnline(true);
              setState(() {});
              print("Connection establised.");
            } else if (message == "send:success") {
              print("Message send success");
              setState(() {
                msgtext.text = "";
              });
            } else if (message == "send:error") {
              print("Message send error");
            } else if (message.substring(0, 6) == "{'cmd'") {
              streamController.add(message);
              // print("Message datathanne");

              message = message.replaceAll(RegExp("'"), '"');
              var jsondata = json.decode(message);

              msglist.add(MessageData(
                //on message recieve, add data to model
                msgtext: jsondata["msgtext"],
                userid: jsondata["userid"],
                isme: false,
              ));
              setState(() {
                //update UI after adding data to message model
              });
            }
          });
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

  // Future<void> sendmsg(String sendmsg, String id) async {
  //   if (connected == true) {
  //     String msg =
  //         "{'auth':'$auth','cmd':'send','userid':'$id', 'msgtext':'$sendmsg'}";
  //     setState(() {
  //       msgtext.text = "";
  //       msglist.add(MessageData(msgtext: sendmsg, userid: myid, isme: true));
  //     });
  //     channel.sink.add(msg); //send message to reciever channel
  //   } else {
  //     channelconnect();
  //     print("Websocket is not connected.");
  //   }
  // }

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
                      recieverid: accounts[index].username,
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MessageData {
  //message data model
  String msgtext, userid;
  bool isme;
  MessageData({
    required this.msgtext,
    required this.userid,
    required this.isme,
  });
}
