import 'package:auto_route/auto_route.dart';
import 'package:client/pages/settings/settings_view_model.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => SettingsViewModel(context),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 20),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  'Account Settings',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
              InkWell(
                onTap: () => context.router.push(const ProfileRoute()),
                child: const Card(
                  child: ListTile(
                    leading: Icon(Icons.account_circle_outlined),
                    title: Text('Profile'),
                    subtitle: Text('edit profile, username'),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Card(
                  child: ListTile(
                    leading: Icon(Icons.email_outlined),
                    title: Text('Email'),
                    subtitle: Text('edit email'),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Card(
                  child: ListTile(
                    leading: Icon(Icons.password_rounded),
                    title: Text('Password reset'),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 10),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  'App Settings',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_outlined),
                  title: Text('Notifications'),
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.chat_outlined),
                  title: Text('Chats'),
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.storage_rounded),
                  title: Text('Storage '),
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.help_outline_rounded),
                  title: Text('Help'),
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Text(
                  'Protecting Your Privacy',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  privacy_policy,
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  var privacy_policy =
      " Click here to review our Privacy Policy which explains how we handle and secure your personal information while using our Android chat app.";

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () => context.router.pop(),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Color.fromARGB(255, 67, 81, 105),
          ),
        ),
      ),
    );
  }
}
