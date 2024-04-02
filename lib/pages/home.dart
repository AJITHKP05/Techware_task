import 'package:flutter/material.dart';
import 'package:task/services/Repository/local_storage.dart';

import 'auth_checker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(
        onPressed: () {
          LocalStorage.setUserLoggedId(null);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
builder: (context) => AuthCheckerPage()), (Route route) => false);
        },
        child: Text("sign out"),
      ),
    );
  }
}