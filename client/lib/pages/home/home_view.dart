import 'package:auto_route/auto_route.dart';
import 'package:client/pages/home/home_view_model.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:client/provider/user_provider.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/get_data_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/io.dart';

import '../../models/user_model.dart';
import '../../services/web_socket_set_up.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late IOWebSocketChannel channel; //channel varaible for websocket

  List<User> accounts = [];
  GetDataService getData = GetDataService();

  void getAllUsers(BuildContext context) async {
    accounts = await getData.allUsers(context: context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllUsers(context);
    channelconnect(context);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(context),
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
                  onTap: viewModel.checkAvailableUsers,
                  child: Icon(Icons.circle,
                      color: context.watch<UserProvider>().user.isOnline
                          ? Colors.greenAccent
                          : Colors.redAccent),
                ),
                TextButton(
                  onPressed: viewModel.logOut,
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
                    ChatRoute(senderId: accounts[index].username),
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
