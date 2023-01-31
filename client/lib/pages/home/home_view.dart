import 'package:auto_route/auto_route.dart';
import 'package:client/pages/home/home_view_model.dart';
import 'package:client/provider/user_provider.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/get_data_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            ),
          ),
          body: ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  context.router.push(
                    ChatRoute(
                      myid: Provider.of<UserProvider>(context, listen: false)
                          .user
                          .username,
                      recieverid: accounts[index].username,
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
