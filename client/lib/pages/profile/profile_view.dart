// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/models/user_model.dart';
import 'package:client/pages/profile/profile_view_model.dart';
import 'package:client/provider/user_provider.dart';
import 'package:client/utils/show_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import 'avatar/svg_rapper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DrawableRoot? svgRoot = null;
  _generateSvg(String? svgCode) async {
    svgCode ??= multiavatar('X-SLAYER');
    return SvgWrapper(svgCode).generateLogo().then((value) {
      setState(() {
        svgRoot = value!;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateSvg(context.read<UserProvider>().user.avatar);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    final TextEditingController first_name_controller =
        TextEditingController(text: 'Safvan');
    final TextEditingController second_name_controller =
        TextEditingController(text: 'Safvan');
    final TextEditingController username_controller =
        TextEditingController(text: user.username);
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
        builder: (context, viewModel, child) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: _buildAppBar(context),
            body: Container(
              color: const Color.fromARGB(255, 245, 239, 239),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.topCenter,
                    child: svgRoot == null
                        ? const CircleAvatar()
                        : showAvatar(svgRoot!, false),
                  ),
                  TextButton(
                    onPressed: () => viewModel.changeProfilePicture(),
                    child: const Text('Change profile picture'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        child: Column(
                      children: [
                        TextFormField(
                          controller: first_name_controller,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('First name'),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: second_name_controller,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('Second name'),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: username_controller,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('Username'),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    )),
                  )
                ],
              ),
            ),
          );
        });
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        leading: TextButton.icon(
            onPressed: () => context.router.pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
            label: const Text('Settings')),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 239, 239),
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                context.router.pop();
              },
              child: Text(
                'Done',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .merge(const TextStyle(color: Colors.blueAccent)),
              ))
        ],
      ),
    );
  }
}
