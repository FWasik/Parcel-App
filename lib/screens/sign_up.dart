import 'package:flutter_bloc/flutter_bloc.dart';
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import 'package:email_validator/email_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/screens/main_page.dart';
import 'package:parcel_app/screens/sign_in.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/menu_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/l10n/localization.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  RegExp regExp = RegExp(r'^[0-9]{9}$');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Localization.init(context);
    var appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(appLoc.signUp),
        actions: [CustomMenu()],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
            );
          }
          if (state is SignedUp) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SignIn(),
              ),
            );
          }
          if (state is AuthError) {
            Utils.showSnackBar(state.error, Colors.red, appLoc.dissmiss);
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return CustomCircularProgressIndicator(
                color: Theme.of(context).primaryColor);
          }
          if (state is UnAuthenticated) {
            return BlocBuilder<FontBloc, FontState>(
                builder: (context, stateFont) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Text(
                                appLoc.signUp,
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                controller: passwordController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock,
                                        color: Theme.of(context).primaryColor),
                                    hintText: appLoc.password,
                                    border: const OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2),
                                    )),
                                obscureText: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value != null && value.length < 6
                                      ? appLoc.validPass
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                initialValue: passwordController.text,
                                cursorColor: Colors.white,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock,
                                        color: Theme.of(context).primaryColor),
                                    hintText: appLoc.confirmPassword,
                                    border: const OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2),
                                    )),
                                obscureText: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) => value != null &&
                                        value != passwordController.text
                                    ? appLoc.validPass
                                    : null,
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value == null ||
                                          !regExp.hasMatch(value)
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                  onPressed: () {
                                    _createAccountWithEmailAndPassword(context);
                                  },
                                  text: Text(appLoc.signUp,
                                      style: TextStyle(
                                          fontSize: 28 * stateFont.resize)),
                                  icon: const Icon(Icons.lock_open, size: 32),
                                  color: Theme.of(context).primaryColor),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<ThemeBloc, ThemeState>(
                            builder: (context, state) {
                          return RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: state.color,
                                    fontSize: 20 * stateFont.resize),
                                text: appLoc.askHaveAccount,
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignIn()),
                                        );
                                      },
                                    text: appLoc.signInButton,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blueAccent,
                                        fontSize: 20 * stateFont.resize),
                                  ),
                                ]),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            });
          }
          return Container();
        },
      ),
    );
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpRequested(emailController.text, passwordController.text,
                phoneNumberController.text, fullNameController.text),
          );
    }
  }
}
