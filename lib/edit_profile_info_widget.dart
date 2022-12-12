import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:parcel_app/profile_info_widget.dart';
import 'package:parcel_app/signup_widget.dart';

import 'package:parcel_app/utils.dart';

class EditProfileInfoWidget extends StatefulWidget {
  const EditProfileInfoWidget({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  final String uid;
  final String email;
  final String firstName;
  final String lastName;

  @override
  _EditProfileInfoWidgetState createState() => _EditProfileInfoWidgetState();
}

class _EditProfileInfoWidgetState extends State<EditProfileInfoWidget> {
  final formKey = GlobalKey<FormState>();
  late final emailController = TextEditingController();
  late final firstNameController = TextEditingController();
  late final lastNameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _validateEmail = false;
  bool _validatePass = false;

  @override
  void initState() {
    super.initState();

    emailController.text = widget.email;
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Update profile"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Profile Info",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
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
                    Text(
                      "Type password to authenticate",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 16),
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
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                      ),
                      icon: Icon(Icons.arrow_forward, size: 32),
                      label: Text(
                        "Update",
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: () => editUserName(
                        uid: widget.uid,
                        email: emailController.text.trim(),
                        firstName: firstNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                        password: passwordController.text.trim(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Future<Map<String, dynamic>> getUserInfo({required String uid}) async {
    var data;
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get()
          .then((DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
      });
    } catch (e) {
      print(e);

      Utils.showSnackBar("Error - contact administator", Colors.red);
      await FirebaseAuth.instance.signOut();
    }
    return data;
  }

  Future<void> editUserName({
    required String firstName,
    required String lastName,
    required String email,
    required String uid,
    required String password,
  }) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseFirestore.instance.collection('Users').doc(uid).update(
          {"email": email, 'firstName': firstName, 'lastName': lastName});

      User user = FirebaseAuth.instance.currentUser!;
      await user.updateEmail(email);
      // await user.reauthenticateWithCredential(
      //     EmailAuthProvider.credential(email: email, password: password));

      // FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: email, password: password);

      Utils.showSnackBar("You successful updated profile!", Colors.green);
    } on FirebaseAuthException catch (error) {
      Utils.showSnackBar(error.message, Colors.red);
    } catch (e) {
      print(e);

      Utils.showSnackBar("Error - contact administator", Colors.red);
      await FirebaseAuth.instance.signOut();
    }
  }
}
