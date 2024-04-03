import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/constants.dart';

class FirebaseRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final SharedPreferences prefs;
  Future loginUsinEmail(email, password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      prefs = await SharedPreferences.getInstance();
      await prefs.setString(appTocken, result.user?.uid ?? "");
      return "LoggedIn";
    } catch (e) {
      return e;
    }
  }

  Future signupUsingEmail(email, password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      prefs = await SharedPreferences.getInstance();
      await prefs.setString(appTocken, result.user?.uid ?? "");
      return signedUp;
    } catch (e) {
      return e;
    }
  }

  Future signout() async {
    _auth.signOut();
  }
}
