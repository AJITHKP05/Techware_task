import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/services/Auth/constants.dart';

class LocalStorage {
  static Future<void> setUserLoggedId(String? value) async {
    final shared = await SharedPreferences.getInstance();
    if (value == null) {
      shared.remove(appTocken);
    } else {
      shared.setString(appTocken, value);
    }
  }

  static Future getUserLoggedId() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getString(appTocken);
  }
}
