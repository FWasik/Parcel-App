import 'package:firebase_auth/firebase_auth.dart';
import 'package:parcel_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _validateEmail = false;
  bool _validatePass = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              TextField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: "Email",
                    errorText: _validateEmail ? "Email cannot be empty" : null),
              ),
              SizedBox(height: 4),
              TextField(
                controller: passwordController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    labelText: "Password",
                    errorText:
                        _validatePass ? "Password cannot be empty" : null),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                icon: Icon(Icons.lock_open, size: 32),
                label: Text(
                  "Sign In",
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  setState(() {
                    emailController.text.isEmpty
                        ? _validateEmail = true
                        : _validateEmail = false;
                    passwordController.text.isEmpty
                        ? _validatePass = true
                        : _validatePass = false;
                  });

                  signIn();
                },
              )
            ],
          ),
        ),
      );

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
        case "wrong-password":
        case "user-not-found":
          {
            Fluttertoast.showToast(
                msg: "Invalid email or password!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          break;

        default:
          {
            print(error);
          }
          break;
      }
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
