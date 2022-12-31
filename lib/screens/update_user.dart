import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/bloc/auth_bloc.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/widgets/button_widget.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser(
      {required this.uid,
      required this.email,
      required this.phoneNumber,
      required this.fullName});

  final String uid;
  final String email;
  final String phoneNumber;
  final String fullName;

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final formKey = GlobalKey<FormState>();
  late final emailController = TextEditingController();
  late final phoneNumberController = TextEditingController();
  late final fullNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    emailController.text = widget.email;
    phoneNumberController.text = widget.phoneNumber;
    fullNameController.text = widget.fullName;
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    fullNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Update profile"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) async {
        if (state is Updated) {
          context.read<AuthBloc>().add(UnUpdatedRequested());

          Navigator.of(context).pop();
        } else if (state is UpdateFailed) {
          Utils.showSnackBar(state.error, Colors.red);

          context.read<AuthBloc>().add(UnUpdatedRequested());
        } else if (state is UnAuthenticated) {
          Navigator.of(context).popUntil((route) => route.isFirst);

          Utils.showSnackBar("You are unathenticated! Log in!", Colors.red);
        }
      }, builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Update profile",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
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
                            prefixIcon:
                                Icon(Icons.person, color: Colors.indigo),
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
                        height: 18,
                      ),
                      CustomButton(
                          width: 0.7,
                          color: Theme.of(context).primaryColor,
                          icon: const Icon(Icons.arrow_forward, size: 32),
                          text: const Text(
                            "Update",
                            style: TextStyle(fontSize: 24),
                          ),
                          onPressed: () {
                            _updateUserInfo(context, uid);
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  void _updateUserInfo(BuildContext context, String uid) {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(UpdateUserRequested(
          uid,
          emailController.text,
          phoneNumberController.text,
          fullNameController.text));
    }
  }
}
