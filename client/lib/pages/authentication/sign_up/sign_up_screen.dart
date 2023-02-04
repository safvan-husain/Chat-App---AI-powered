import 'package:auto_route/auto_route.dart';
import 'package:client/pages/authentication/sign_up/sign_up_view_model.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  late String _email;
  late String _username;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: (() => SignUpViewModel()),
      builder: (context, viewModel, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, Colors.purple])),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                  ),
                  const Text(
                    "Sign UP",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email';
                      } else {
                        _email = value;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email';
                      } else {
                        _username = value;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      } else {
                        _password = value;
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          viewModel.register(
                            context: context,
                            email: _email,
                            username: _username,
                            password: _password,
                          );
                        }
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () {
                        context.router.push(const SignInRoute());
                      },
                      child: const Text("Already have an account? Sign In"),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to the Forgot Password screen
                      },
                      child: const Text("Forgot Password?"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
