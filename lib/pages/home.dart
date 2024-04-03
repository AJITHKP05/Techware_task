import 'package:flutter/material.dart';
import 'package:task/Utils/toast.dart';
import 'package:task/services/Repository/local_storage.dart';
import '../CommonWidgets/pin_set_propmt.dart';
import '../services/Repository/firebase_repository.dart';
import 'auth_checker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var fire = FirebaseRepository();
  @override
  void initState() {
    checkForPin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(
        onPressed: () {
          signOut();
        },
        child: const Text("sign out"),
      ),
    );
  }

  Future<void> checkForPin() async {
    bool? value = await LocalStorage.isPinPromptShown();
    String? pin = await LocalStorage.getUserPin();
    if ((value != null && !value) && pin == null) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context, barrierDismissible: false,
        builder: (BuildContext context) {
          return const PinSetPrompt();
        },
      );
    }
  }

  void signOut() {
    LocalStorage.setUserLoggedId(null);
    LocalStorage.setPinPromptShown(false);
    fire.signout();
    successToast("Logged Out");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthCheckerPage()),
        (Route route) => false);
  }
}
