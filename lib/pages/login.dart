import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/pages/home.dart';

import '../BlockPattern/login_cubit/login_cubit.dart';
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

  @override
  Widget build(BuildContext conte) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocProvider(
        create: (contex) => LoginCubit(),
        child: Builder(builder: (context) {
          return BlocConsumer<LoginCubit, LoginCubitState>(
            listener: (context, state) {
              if (state is LoginCubitError) {
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
                child: Form(
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
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
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Password'),
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
                      TextButton(
                          onPressed: () {
                            widget.toggle();
                          },
                          child: const Text("Register")),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            context.read<LoginCubit>().logIn(
                                emailController.text, passwordController.text);
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
