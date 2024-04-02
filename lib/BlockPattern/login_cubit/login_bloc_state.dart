part of 'login_cubit.dart';

@immutable
sealed class LoginCubitState {}

final class LoginCubitInitial extends LoginCubitState {}

final class LoginCubitLoading extends LoginCubitState {}

final class LoginCubitLoggedIn extends LoginCubitState {}

final class LoginCubitError extends LoginCubitState {
  final String? error;

  LoginCubitError({required this.error});
}
