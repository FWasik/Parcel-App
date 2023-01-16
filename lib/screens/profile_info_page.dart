import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
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

        var appLoc = AppLocalizations.of(context)!;

        return Container(
          padding: const EdgeInsets.all(18),
          child:
              BlocBuilder<FontBloc, FontState>(builder: (context, stateFont) {
            return Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appLoc.editProfile,
                        style: TextStyle(
                          fontSize: 38 * stateFont.resize,
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
                        style: TextStyle(fontSize: 16 * stateFont.resize),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value != null &&
                                  !EmailValidator.validate(value)
                              ? appLoc.validEmail
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
                            hintText: appLoc.phoneNumber,
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            )),
                        style: TextStyle(fontSize: 16 * stateFont.resize),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value == null || !regExp.hasMatch(value)
                              ? appLoc.validPhoneNumber
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
                            hintText: appLoc.fullName,
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            )),
                        style: TextStyle(fontSize: 16 * stateFont.resize),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value == null || value.isEmpty
                              ? appLoc.validFullName
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
                          text: Text(
                            appLoc.edit,
                            style: TextStyle(fontSize: 28 * stateFont.resize),
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
