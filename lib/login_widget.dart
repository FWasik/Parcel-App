import 'package:firebase_auth/firebase_auth.dart';
import 'package:parcel_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parcel_app/utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

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
              ),
              SizedBox(height: 24),
              RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    text: "No account? ",
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: "Sign up",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ]),
              ),
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
      Utils.showSnackBar(error.message);

      print(error);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
