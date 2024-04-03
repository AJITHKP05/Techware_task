import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/services/Repository/local_storage.dart';

import '../../services/Auth/constants.dart';
import '../../services/Repository/firebase_repository.dart';

part 'login_bloc_state.dart';

class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit() : super(LoginCubitInitial());
  final _fire = FirebaseRepository();

  Future logIn(email, password) async {
    emit(LoginCubitLoading());
    _fire.loginUsinEmail(email, password).then((value) {
      if (value == loggedIn) {
        return emit(LoginCubitLoggedIn());
      } else {
        if (value.code == "invalid-credential") {
          return emit(LoginCubitError(error: "Invalid credentials"));
        }
        if (value.code == "too-many-requests") {
          return emit(
              LoginCubitError(error: "Too many requests, Please try later"));
        } else {
          return emit(
              LoginCubitError(error: "Failed to sign in. Please try again."));
        }
      }
    });
  }

  void logInWithPin(String pin) async {
    emit(LoginCubitLoading());
    var prefs = await SharedPreferences.getInstance();
    LocalStorage.getUserPin().then((value) {
      if (value == pin) {
        prefs.setString(appTocken, value);
        LocalStorage.setPinPromptShown(true);
        return emit(LoginCubitLoggedIn());
      } else {
        return emit(LoginPinCubitError(error: "Failed"));
      }
    });
  }
}
