import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../services/Auth/constants.dart';
import '../../services/Repository/firebase_repository.dart';

part 'signup_cubit_state.dart';

class SignupCubit extends Cubit<SignupCubitState> {
  SignupCubit() : super(SignupCubitInitial());
  final fire = FirebaseRepository();
  Future signup(email, password) async {
    emit(SignupCubitLoading());
    fire.signupUsingEmail(email, password).then((value) {
      if (value == signedUp) {
        return emit(SignupCubitLSuccess());
      } else {
        if (value.code == "invalid-credential") {
          return emit(SignupCubitError(error: "Invalid credentials"));
        }
        if (value.code == "too-many-requests") {
          return emit(
              SignupCubitError(error: "Too many requests, Please try later"));
        } else {
          return emit(
              SignupCubitError(error: "Failed to register. Please try again."));
        }
      }
    });
  }
}
