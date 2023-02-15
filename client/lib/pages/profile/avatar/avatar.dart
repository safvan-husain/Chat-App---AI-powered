import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dd;
import 'package:auto_route/auto_route.dart';
import 'package:client/constance/http_error_handler.dart';
import 'package:client/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:client/pages/profile/avatar/my_painter.dart';
import 'package:client/pages/profile/avatar/svg_rapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:provider/provider.dart';

import '../../../constance/constant_variebles.dart';
import '../../../models/user_model.dart';
import '../../../utils/get_token_storage.dart';

class HoemPage extends StatefulWidget {
  @override
  _HoemPageState createState() => _HoemPageState();
}

class _HoemPageState extends State<HoemPage> {
  String svgCode = multiavatar('X-SLAYER');
  DrawableRoot? svgRoot;
  TextEditingController randomField = TextEditingController();

  _generateSvg() async {
    return SvgWrapper(svgCode).generateLogo().then((value) {
      setState(() {
        svgRoot = value!;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _generateSvg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF141E30),
              Color(0xFF243B55),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  svgRoot == null ? CircleAvatar() : _avatarPreview(),
                  const SizedBox(height: 35.0),
                  _textField(),
                  const SizedBox(height: 40.0),
                  const Text(
                    "In total, it is possible to generate 12 billion unique avatars.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 17.0),
                  ),
                  const SizedBox(height: 25.0),
                  _randomButton(),
                  ElevatedButton(
                      onPressed: () async {
                        http.Response response = await http.post(
                          Uri.parse('$uri/profile/change-dp'),
                          headers: <String, String>{
                            'content-type': 'application/json; charset=utf-8',
                            'x-auth-token':
                                await getTokenFromStorage() as String,
                          },
                          body: jsonEncode({
                            'avatar': svgCode,
                          }),
                        );
                        if (context.mounted) {}
                        httpErrorHandler(
                          context: context,
                          response: response,
                          onSuccess: () {
                            User user = Provider.of<UserProvider>(context,
                                    listen: false)
                                .user;
                            User newUser = User.fromJson(response.body);
                            Provider.of<UserProvider>(context, listen: false)
                                .setUser(user.copyWith(avatar: newUser.avatar));
                            context.router.pop();
                          },
                        );
                      },
                      child: const Text('save'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatarPreview() {
    return Container(
      height: 180.0,
      width: 180.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: svgRoot == null
          ? const SizedBox.shrink()
          : CustomPaint(
              painter: MyPainter(svgRoot!, const Size(180.0, 180.0)),
              child: Container(),
            ),
    );
  }

  Widget _textField() {
    return TextField(
      controller: randomField,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
      onChanged: (field) {
        if (field.isNotEmpty) {
          setState(() {
            svgCode = multiavatar(field);
          });
          // dev.log(svgCode);
        } else {
          setState(() {
            svgCode = multiavatar('X-SLAYER');
          });
        }

        _generateSvg();
      },
      decoration: const InputDecoration(
        fillColor: Colors.white10,
        border: InputBorder.none,
        filled: true,
        hintText: "type anything here",
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _randomButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white10,
        child: IconButton(
            onPressed: () {
              var l = new List.generate(12, (_) => new Random().nextInt(100));
              randomField.text = l.join();
              setState(() {
                svgCode = multiavatar(randomField.text);
              });
              _generateSvg();
            },
            icon: const Icon(
              Icons.refresh,
              size: 30.0,
              color: Colors.white60,
            )),
      ),
    );
  }
}
