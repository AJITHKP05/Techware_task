import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task/CommonWidgets/common_buttons.dart';
import 'package:task/Utils/toast.dart';
import 'package:task/services/Repository/local_storage.dart';
import '../BlockPattern/firestore_cubit/firestore_cubit.dart';
import '../CommonWidgets/add_product_fab.dart';
import '../CommonWidgets/pin_change_prompt.dart';
import '../CommonWidgets/pin_clear_switch.dart';
import '../CommonWidgets/pin_set_propmt.dart';
import '../CommonWidgets/qr_view.dart';
import '../CommonWidgets/search_bar.dart';
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
            CommonTextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            CommonButtonText(
              onPressed: () {
                signOut(keepPin);
              },
              child: "Sign out",
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: const AddProductFab(),
          appBar: AppBar(
            centerTitle: true,
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
            ],
          ),
          body: BlocProvider(
            create: (context) => FirestoreCubit(),
            child: const FirestoreDataWidget(),
          ),
        ),
      ),
    );
  }

  Future<void> checkForPin() async {
    bool value = await LocalStorage.isPinPromptShown() ?? false;
    authPin = await LocalStorage.getUserPin();

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
    successToast("Logged Out",context);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthCheckerPage()),
        (Route route) => false);
  }
}

class FirestoreDataWidget extends StatefulWidget {
  const FirestoreDataWidget({super.key});

  @override
  State<FirestoreDataWidget> createState() => _FirestoreDataWidgetState();
}

class _FirestoreDataWidgetState extends State<FirestoreDataWidget> {
  final TextEditingController _searchController = TextEditingController();

  late PermissionStatus cameraPermissionStatus;
  Future permissionCheck() async {
    cameraPermissionStatus = await Permission.camera.status;
    await Permission.camera.request();
    // if (status.isDenied || status.isPermanentlyDenied) {
    //   // openAppSettings().then((value) => null);
    //   print("in condition");
    // }
  }

  @override
  void initState() {
    permissionCheck();
    super.initState();
  }

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
            return Image.asset("assets/empty.jpeg");
          }
          final filteredDocs = state.documents
              .where((doc) => doc['name']
                  .toString()
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList();

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SearchBarWidget(
                      onIconClick: () async {
                        if (await Permission.camera.status.isGranted) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => QRScanner(
                              onDetect: (p0) {
                                _searchController.text = p0 ?? "";
                                setState(() {});
                              },
                            ),
                          ));
                        } else {
                          openAppSettings();
                          successToast("Camera Permisssion needed",context);
                        }
                      },
                      searchController: _searchController,
                      onChanged: () {
                        setState(() {});
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                (filteredDocs.isEmpty)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.asset("assets/empty.jpeg"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final document = filteredDocs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                foregroundImage: NetworkImage(
                                    "https://ui-avatars.com/api/?name=${document["name"]}"),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              tileColor: Colors.blueGrey[200],
                              onTap: () {
                                Navigator.push(
                                    context,
                                    createRoute(
                                        ProductDetailPage(data: document))
                                    // MaterialPageRoute(
                                    //   builder: (context) =>
                                    //       ProductDetailPage(data: document),
                                    // )
                                    );
                              },
                              trailing: const Icon(Icons.arrow_forward_ios),
                              title: Text(document["name"]),
                              subtitle: Text(document['measurement']),
                            ),
                          );
                        },
                      ),
              ],
            ),
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

Route createRoute(Widget page2) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page2,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
