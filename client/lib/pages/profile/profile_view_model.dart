import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:client/constance/http_error_handler.dart';
import 'package:client/pages/profile/avatar/avatar.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/utils/get_token_storage.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../constance/constant_variebles.dart';

class ProfileViewModel extends BaseViewModel {
  final BuildContext context;

  ProfileViewModel(this.context);
  final cloudinary = CloudinaryPublic('djrmgocda', 'ktwsuong', cache: false);
  void changeProfilePicture() async {
    context.router.push(const HoemRoute());
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // if (image == null) return;
    // try {
    //   CloudinaryResponse image_response = await cloudinary.uploadFile(
    //     CloudinaryFile.fromFile(image.path,
    //         resourceType: CloudinaryResourceType.Image),
    //   );
    //   http.Response response = await http.post(
    //     Uri.parse('$uri/profile/change-dp'),
    //     headers: <String, String>{
    //       'content-type': 'application/json; charset=utf-8',
    //       'x-auth-token': await getTokenFromStorage() as String,
    //     },
    //     body: jsonEncode({
    //       'avatar': image_response.secureUrl,
    //     }),
    //   );
    //   if (context.mounted) {}
    //   httpErrorHandler(
    //     context: context,
    //     response: response,
    //     onSuccess: () {},
    //   );
    // } on CloudinaryException catch (e) {
    //   print(e.message);
    //   print(e.request);
    // }
  }
}
