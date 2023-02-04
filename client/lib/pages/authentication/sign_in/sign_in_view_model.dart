import 'package:client/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignInViewModel extends BaseViewModel {
  AuthServices authServices = AuthServices();
  void login(
    String username,
    String password,
    BuildContext context,
  ) {
    authServices.login(
      context: context,
      username: username,
      password: password,
    );
  }
}
