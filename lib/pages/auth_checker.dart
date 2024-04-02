import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/pages/home.dart';
import 'package:task/pages/login.dart';
import 'package:task/pages/signup.dart';

import '../services/Auth/constants.dart';
import '../services/Repository/local_storage.dart';

class AuthCheckerPage extends StatefulWidget {
  const AuthCheckerPage({super.key});

  @override
  State<AuthCheckerPage> createState() => _AuthCheckerPageState();
}

class _AuthCheckerPageState extends State<AuthCheckerPage> {

   bool isSignIn = true;
  String? alreadyIn ;
  void toggle() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    checkForLogedIn();

    return alreadyIn!=null
        ? const HomePage()
        : isSignIn
            ? LoginPage(
                toggle: toggle,
              )
            : SignupPage(
              toggle: toggle
              );
  }

  Future<void> checkForLogedIn() async {
    String? value = await LocalStorage.getUserLoggedId();
    if (value != null) alreadyIn = value;
    setState(() {});
  }
}