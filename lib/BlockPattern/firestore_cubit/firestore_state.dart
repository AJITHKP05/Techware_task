part of 'firestore_cubit.dart';

@immutable
sealed class FirestoreState {}

final class FirestoreInitial extends FirestoreState {}
final class FirestoreLoading extends FirestoreState {}
final class FirestoreData extends FirestoreState {
   final List<DocumentSnapshot> documents;

  FirestoreData({required this.documents});
}
final class FirestoreError extends FirestoreState {
  final String error;

  FirestoreError({required this.error});
}
