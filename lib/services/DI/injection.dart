// import 'package:get_it/get_it.dart';
// import 'package:task/BlockPattern/login_cubit/login_cubit.dart';
// import 'package:task/services/Repository/firebase_repository.dart';
// abstract class FDI {
//   static GetIt _fdin = GetIt.instance;

//   /// provides instance of [object] registered in GetIt instance
//   static GetIt get i => _fdin;

//   static Future<void> initialize() async {
//      _fdin.registerFactory(() => LoginCubit(_fdin()));
//      _fdin.registerLazySingleton<FirebaseRepository>(
//         () => FirebaseRepository(_fdin()));
//   }
// }
