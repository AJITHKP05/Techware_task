import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../services/Repository/local_storage.dart';

part 'pin_set_state.dart';

class PinSetCubit extends Cubit<PinSetState> {
  PinSetCubit() : super(PinSetInitial());

  Future setPin(String value) async {
    emit(PinSetLoading());
    try {
      LocalStorage.setUserPin(value);
      LocalStorage.setPinPromptShown(true);
      emit(PinSetSuccess());
    } catch (e) {
      emit(PinSetError(error: "Something went wrong"));
    }
  }

  Future skipPin() async {
     LocalStorage.setPinPromptShown(true);
  }
}
