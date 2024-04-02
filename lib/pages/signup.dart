import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  
  Function(bool)? toggle;

  SignupPage({super.key,this.toggle});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
   
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email, _password;
  bool _isLoading = false;

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState?.save();

      try {
        await _auth.createUserWithEmailAndPassword(
          email: _email ?? "",
          password: _password ?? "",
        );
        // Navigate to home screen after successful login
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HomeScreen(),
        //   ),
        // );
        _isLoading = true;
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("error");
        print(e.toString());
        // Handle login errors here
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to sign in. Please try again."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
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
                      onSaved: (input) => _email = input,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Please provide a password';
                        }
                        return null;
                      },
                      onSaved: (input) => _password = input,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signIn,
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
