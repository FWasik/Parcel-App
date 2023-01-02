import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';

import 'package:parcel_app/bloc/auth_bloc.dart';
import 'package:parcel_app/models/custom_user.dart';
import 'package:parcel_app/widgets/button_widget.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({Key? key}) : super(key: key);

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final fullNameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    fullNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is UnAuthenticated) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }, builder: (context, state) {
      if (state is Authenticated) {
        CustomUser? user = state.user!;
        emailController.text = user.email;
        phoneNumberController.text = user.phoneNumber;
        fullNameController.text = user.fullName;

        return Container(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Edit profile",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail, color: Colors.indigo),
                          hintText: "Email",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 2),
                          )),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value != null && !EmailValidator.validate(value)
                            ? 'Enter a valid email'
                            : null;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone, color: Colors.indigo),
                          hintText: "Phone number",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 2),
                          )),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? "Phone number cannot be empty"
                            : null;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.indigo),
                          hintText: "Full name",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 2),
                          )),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? "Full name cannot be empty"
                            : null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        width: 0.7,
                        color: Theme.of(context).primaryColor,
                        icon: const Icon(Icons.arrow_forward, size: 32),
                        text: const Text(
                          "Edit",
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: () {
                          _editUserInfo(context, uid);
                        }),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (state is Loading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Container();
      }
    }));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deleting an account'),
          content: const SingleChildScrollView(
            child: Text(
              'Are you sure you want to delete an account?',
              style: TextStyle(fontSize: 18),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              onPressed: () {
                context.read<AuthBloc>().add(DeleteUserRequested(uid));

                Navigator.of(context).popUntil((route) => route.isFirst);

                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => const SignIn()),
                //     (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void _editUserInfo(BuildContext context, String uid) {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(EditUserRequested(uid, emailController.text,
          phoneNumberController.text, fullNameController.text));
    }
  }
}
