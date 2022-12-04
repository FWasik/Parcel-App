import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:parcel_app/main.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import 'package:email_validator/email_validator.dart';
import 'package:parcel_app/utils.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool _validateEmail = false;
  bool _validatePass = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlutterLogo(size: 100),
                  SizedBox(height: 20),
                  Text(
                    "Welcome to Parcel App!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "Email"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? "Enter a valid email"
                            : null,
                  ),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: passwordController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 6
                        ? "Enter min. 6 characters"
                        : null,
                  ),
                  SizedBox(height: 4),
                  TextFormField(
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: "Confirm password"),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value != null && value != passwordController.text
                            ? "Passwords are different"
                            : null,
                  ),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: firstNameController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: "First name"),
                  ),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: lastNameController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: "Last name"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                    ),
                    icon: Icon(Icons.arrow_forward, size: 32),
                    label: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: signUp,
                  ),
                  SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignIn,
                            text: "Sign in",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.cyan),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future userProfileData(
      {required String firstName,
      required String lastName,
      required String email,
      required String uid}) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .set({"email": email, "firstName": firstName, "lastName": lastName});
    } catch (error) {
      print(error);

      Utils.showSnackBar("Error - contact administator", Colors.red);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final String myUid = user!.uid;

      userProfileData(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          uid: myUid);

      await FirebaseAuth.instance.signOut();

      Utils.showSnackBar("You signed up an account!", Colors.green);
    } on FirebaseAuthException catch (error) {
      print(error);

      Utils.showSnackBar(error.message, Colors.red);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
