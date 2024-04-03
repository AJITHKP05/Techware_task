import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/CommonWidgets/common_buttons.dart';
import 'package:task/Utils/toast.dart';
import 'package:task/services/Repository/local_storage.dart';
import '../BlockPattern/firestore_cubit/firestore_cubit.dart';
import '../CommonWidgets/add_product_fab.dart';
import '../CommonWidgets/pin_change_prompt.dart';
import '../CommonWidgets/pin_clear_switch.dart';
import '../CommonWidgets/pin_set_propmt.dart';
import '../services/Repository/firebase_repository.dart';
import 'auth_checker.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var fire = FirebaseRepository();
  String? authPin;
  @override
  void initState() {
    checkForPin();
    super.initState();
  }

  void confirmExit(bool isPinUsed) {
    bool keepPin = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sign out"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Are you sure to sign out?"),
              const SizedBox(
                height: 8,
              ),
              isPinUsed
                  ? PinClearSwitch(
                      onChange: (p0) {
                        keepPin = p0;
                      },
                    )
                  : Container()
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            CommonButton(
              onPressed: () {
                signOut(keepPin);
              },
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AddProductFab(),
      appBar: AppBar(
        title: const Text("Products List"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == "changePin") {
                showDialog(
                  // ignore: use_build_context_synchronously
                  context: context, barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const PinChangePrompt();
                  },
                );
              }
              if (result == "setPin") {
                showDialog(
                  // ignore: use_build_context_synchronously
                  context: context, barrierDismissible: false,
                  builder: (BuildContext context) {
                    return PinSetPrompt(
                      onSet: () {
                        checkForPin();
                      },
                    );
                  },
                );
              }
              if (result == "logout") {
                confirmExit(authPin != null);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              (authPin != null)
                  ? const PopupMenuItem<String>(
                      value: 'changePin',
                      child: Text('Change PIN'),
                    )
                  : const PopupMenuItem<String>(
                      value: 'setPin',
                      child: Text('Set PIN'),
                    ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Sign out'),
              ),
            ],
          ),
          // IconButton(
          //     onPressed: () {
          //       confirmExit(authPin != null);
          //     },
          //     icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: BlocProvider(
        create: (context) => FirestoreCubit(),
        child: FirestoreDataWidget(),
      ),
    );
  }

  Future<void> checkForPin() async {
    bool value = await LocalStorage.isPinPromptShown() ?? false;
    authPin = await LocalStorage.getUserPin();
    print(authPin);
    if ((!value) && authPin == null) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context, barrierDismissible: false,
        builder: (BuildContext context) {
          return PinSetPrompt(onSet: () {
            checkForPin();
          });
        },
      );
    }
  }

  void signOut(bool keepPin) {
    if (!keepPin) {
      LocalStorage.setPinPromptShown(false);
      LocalStorage.setUserPin(null);
    }
    LocalStorage.setUserLoggedId(null);
    fire.signout();
    successToast("Logged Out");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthCheckerPage()),
        (Route route) => false);
  }
}

class FirestoreDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirestoreCubit, FirestoreState>(
      builder: (context, state) {
        if (state is FirestoreLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FirestoreData) {
          if (state.documents.isEmpty) {
            return const Text("Nothing to show, add a product");
          }
          return ListView.builder(
            itemCount: state.documents.length,
            itemBuilder: (context, index) {
              final document = state.documents[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          data: document,
                        ),
                      ));
                },
                title: Text(document.id),
                subtitle: Text(document['measurement']),
              );
            },
          );
        } else if (state is FirestoreError) {
          return Center(
            child: Text(state.error),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
