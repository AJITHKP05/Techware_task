import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../services/Auth/constants.dart';
import '../../services/Repository/firebase_repository.dart';

part 'login_bloc_state.dart';

class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit() : super(LoginCubitInitial());
  final fire = FirebaseRepository();

  Future logIn(email, password) async {
    emit(LoginCubitLoading());
    fire.loginUsinEmail(email, password).then((value) {
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
}
