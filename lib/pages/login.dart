import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task/pages/home.dart';
import 'package:task/services/Repository/local_storage.dart';

import '../BlockPattern/login_cubit/login_cubit.dart';
import '../CommonWidgets/common_buttons.dart';
import '../CommonWidgets/pin_login_prompt.dart';
import '../Utils/toast.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.toggle});
  Function() toggle;
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPinAvailable = false;
  @override
  void initState() {
    checkForPin();
    super.initState();
  }

  @override
  Widget build(BuildContext conte) {
    return Scaffold(
      appBar: AppBar(
          // centerTitle: true,
          // title: const Text('Login'),
          ),
      body: BlocProvider(
        create: (contex) => LoginCubit(),
        child: Builder(builder: (context) {
          return BlocConsumer<LoginCubit, LoginCubitState>(
            listener: (context, state) {
              if (state is LoginCubitError) {
                successToast(state.error);
              }
              if (state is LoginPinCubitError) {
                successToast(state.error);
              }
              if (state is LoginCubitLoggedIn) {
                successToast("Logged in");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
              }
            },
            builder: (context, state) {
              if (state is LoginCubitLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: [
                        const FlutterLogo(
                          size: 120,
                        ),
                        const SizedBox(height: 48.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Please provide an email';
                            }
                            return null;
                          },
                          controller: emailController,
                          // onSaved: (input) => emailController.text = input??"",
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                          obscureText: true,
                          controller: passwordController,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Please provide a password';
                            }
                            return null;
                          },
                          // onSaved: (input) => passwordController.text = input??"",
                        ),
                        const SizedBox(height: 20),
                        CommonTextButton(
                            onPressed: () {
                              widget.toggle();
                            },
                            child: const Text("Register")),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 60.dp,
                          child: CommonButtonText(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
                                context.read<LoginCubit>().logIn(
                                    emailController.text,
                                    passwordController.text);
                              }
                            },
                            child: 'LogIn',
                          ),
                        ),
                        if (isPinAvailable)
                          TextButton(
                              onPressed: () {
                                _openPinLogin(
                                  (pin) {
                                    context
                                        .read<LoginCubit>()
                                        .logInWithPin(pin);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: const Text("Login with PIN"))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Future checkForPin() async {
    await LocalStorage.getUserPin().then((value) {
      if (value != null) {
        isPinAvailable = true;
        setState(() {});
      } else {
        isPinAvailable = false;
      }
    });
  }

  void _openPinLogin(Function(String) onLogin) {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context, barrierDismissible: false,
      builder: (BuildContext context) {
        return PinLoginPrompt(
          onLogin: onLogin,
        );
      },
    );
  }
}
