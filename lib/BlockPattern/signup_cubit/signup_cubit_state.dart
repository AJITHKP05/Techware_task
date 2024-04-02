part of 'signup_cubit.dart';

@immutable
sealed class SignupCubitState {}

final class SignupCubitInitial extends SignupCubitState {}


final class SignupCubitLoading extends SignupCubitState {}

final class SignupCubitLSuccess extends SignupCubitState {}

final class SignupCubitError extends SignupCubitState {
  final String? error;

  SignupCubitError({required this.error});
}