part of 'pin_set_cubit.dart';

@immutable
sealed class PinSetState {}

final class PinSetInitial extends PinSetState {}

final class PinSetLoading extends PinSetState {}

final class PinSetSuccess extends PinSetState {}

final class PinSetError extends PinSetState {
  final String error;

  PinSetError({required this.error});
}
