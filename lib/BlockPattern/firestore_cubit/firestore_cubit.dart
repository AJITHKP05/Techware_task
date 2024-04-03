import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/Repository/firestore_repository.dart';

part 'firestore_state.dart';

class FirestoreCubit extends Cubit<FirestoreState> {
  FirestoreCubit() : super(FirestoreInitial()) {
    _listenToFirestore();
  }
  StreamSubscription<QuerySnapshot>? _subscription;
  final _fire = FireStoreRepository();

  void _listenToFirestore()async {
    _subscription?.cancel();
    
    _subscription = _fire.getStreamData().listen(
      (querySnapshot) {
        emit(FirestoreData(documents: querySnapshot.docs));
      },
      onError: (error) {
        emit(FirestoreError(error: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    // Cancel the subscription when the Cubit is closed
    _subscription?.cancel();
    return super.close();
  }
}
