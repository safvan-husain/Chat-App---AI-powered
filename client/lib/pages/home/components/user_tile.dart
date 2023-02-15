// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:client/provider/user_provider.dart';
import 'package:client/utils/show_avatar.dart';
import 'package:flutter/material.dart';

import 'package:client/models/user_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:provider/provider.dart';

import '../../../provider/unread_messages.dart';
import '../../profile/avatar/svg_rapper.dart';

class UserTile extends StatefulWidget {
  User user;
  UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  DrawableRoot? svgRoot;
  _generateSvg(String? svgCode) async {
    svgCode ??= multiavatar(widget.user.username);
    return SvgWrapper(svgCode).generateLogo().then((value) {
      setState(() {
        svgRoot = value!;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _generateSvg(widget.user.avatar);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: svgRoot == null ? CircleAvatar() : showAvatar(svgRoot!, true),
      title: Text(widget.user.username),
      trailing: Text(
        Provider.of<Unread>(context)
            .numberOfUnreadMessOf(widget.user.username)
            .toString(),
      ),
    );
  }
}
