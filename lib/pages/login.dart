import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/toast.dart';
import '../services/Auth/constants.dart';

class LoginPage extends StatefulWidget {
   LoginPage({super.key, this.toggle});
  Function(bool)? toggle;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final SharedPreferences prefs;

  bool _isLoading = false;

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState?.save();

      try {
        var result = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Navigate to home screen after successful login

        //   MaterialPageRoute(
        //     builder: (context) => HomeScreen(),
        //   ),
        // );

        // Obtain shared preferences.

        await prefs.setString(appTocken, result.user?.uid ?? "");
        successToast("Logged in");

        _isLoading = true;
        Navigator.pushReplacementNamed(context, "/home");
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(e.toString());
        // Handle login errors here
        successToast("Failed to sign in. Please try again.");
      }
    }
  }

 

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
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
                      decoration: InputDecoration(labelText: 'Password'),
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
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signIn,
                      child: Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
