import 'package:auto_route/auto_route.dart';
import 'package:client/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../constance/full_width_button.dart';
import '../../../routes/router.gr.dart';
import '../../../services/google_auth_services.dart';

class GoogleSignUpPage extends StatelessWidget {
  GoogleSignUpPage({super.key});
  AuthServices authService = AuthServices();
  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? account;
    void googleSignUp() async {
      account = await GoogleSignInApi.login();
      if (account != null) {
        authService.registerUser(
            context: context,
            email: account!.id,
            username: account!.displayName!,
            password: account!.email);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => googleSignUp(),
                icon: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    'assets/google.png',
                    fit: BoxFit.contain,
                  ),
                ),
                label: const Text('Sign Up with Google'),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40)),
              ),
              FullWidthButton(text: "Use Form", onPress: () {}),
              TextButton(
                  onPressed: () {
                    context.router.push(const GoogleSignInRoute());
                  },
                  child: const Text('Have an account? Sign In'))
            ],
          ),
        ),
      ),
    );
  }
}
