import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';

import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
import 'package:parcel_app/models/custom_user.dart';
import 'package:parcel_app/utils/themes.dart';
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

  bool isDark = true;

  RegExp regExp = RegExp(r'^[0-9]{9}$');

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
        body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is Authenticated) {
        CustomUser? user = state.user!;
        emailController.text = user.email;
        phoneNumberController.text = user.phoneNumber;
        fullNameController.text = user.fullName;

        return Container(
          padding: const EdgeInsets.all(18),
          child: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
            return Center(
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
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail,
                                color: Theme.of(context).primaryColor),
                            hintText: "Email",
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            )),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value != null &&
                                  !EmailValidator.validate(value)
                              ? 'Enter a valid email'
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone,
                                color: Theme.of(context).primaryColor),
                            hintText: "Phone number",
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            )),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value == null || !regExp.hasMatch(value)
                              ? "Enter valid phone number"
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person,
                                color: Theme.of(context).primaryColor),
                            hintText: "Full name",
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
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
            );
          }),
        );
      } else if (state is Loading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Container();
      }
    }));
  }

  void _editUserInfo(BuildContext context, String uid) {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(EditUserRequested(uid, emailController.text,
          phoneNumberController.text, fullNameController.text));
    }
  }
}
