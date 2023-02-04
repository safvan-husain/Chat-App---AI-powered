import 'package:client/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignUpViewModel extends BaseViewModel {
  AuthServices authServices = AuthServices();
  void register({
    required BuildContext context,
    required String email,
    required String username,
    required String password,
  }) {
    authServices.registerUser(
      context: context,
      email: email,
      username: username,
      password: password,
    );
  }
}
