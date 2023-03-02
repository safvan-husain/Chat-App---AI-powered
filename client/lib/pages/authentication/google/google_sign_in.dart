import 'package:client/constance/full_width_button.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:auto_route/auto_route.dart';
import '../../../services/google_auth_services.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  AuthServices services = AuthServices();
  GoogleSignInAccount? account;
  void googleSignIn(BuildContext context) async {
    await GoogleSignInApi.logout();
    account = await GoogleSignInApi.login();
    if (account?.email != null) {
      // ignore: use_build_context_synchronously
      services.loginWithGoogle(
        context: context,
        email: account!.id,
      );
    }
  }

  void tokenValidation() {
    services.authenticationByToken(context: context);
  }

  @override
  void initState() {
    super.initState();
    tokenValidation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(181, 1, 178, 181),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () => googleSignIn(context),
              icon: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(
                  'assets/google.png',
                  // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRu1PJmT_THldF0n5APcmt9p10utgu6KSw4cH2fQ5Xhpw&s",
                  fit: BoxFit.fill,
                ),
              ),
              label: const Text(
                'continue with Google',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40)),
            ),
            FullWidthButton(text: "Use Form", onPress: () {}),
            TextButton(
                onPressed: () {
                  context.router.push(GoogleSignUpRoute());
                },
                child: const Text('Don\'t have an account? Sign Up'))
          ],
        ),
      ),
    );
  }
}
