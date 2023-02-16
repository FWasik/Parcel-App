import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
import 'package:parcel_app/screens/main_page.dart';
import 'package:parcel_app/screens/reset_password_page.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/screens/sign_up.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/menu_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/l10n/localization.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Localization.init(context);
    var appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(appLoc.signIn),
        actions: const [CustomMenu()],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (contextAuth, stateAuth) {
          if (stateAuth is Authenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainPage()));
          }
          if (stateAuth is AuthError) {
            Utils.showSnackBar(stateAuth.error, Colors.red, appLoc.dissmiss);
          }
        },
        builder: (contextAuth, stateAuth) {
          if (stateAuth is Loading) {
            return CustomCircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            );
          }
          if (stateAuth is UnAuthenticated || stateAuth is SignedUp) {
            return BlocBuilder<FontBloc, FontState>(
                builder: (context, stateFont) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appLoc.signIn,
                          style: TextStyle(
                            fontSize: 38 * stateFont.resize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Center(
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.mail,
                                          color:
                                              Theme.of(context).primaryColor),
                                      hintText: "Email",
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2),
                                      )),
                                  style: TextStyle(
                                      fontSize: 16 * stateFont.resize),
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
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock,
                                          color:
                                              Theme.of(context).primaryColor),
                                      hintText: appLoc.password,
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2),
                                      )),
                                  style: TextStyle(
                                      fontSize: 16 * stateFont.resize),
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
                                  height: 20,
                                ),
                                CustomButton(
                                    width: 0.7,
                                    onPressed: () {
                                      _authenticateWithEmailAndPassword(
                                          context);
                                    },
                                    text: Text(appLoc.signInButton,
                                        style: TextStyle(
                                            fontSize: 28 * stateFont.resize)),
                                    icon: const Icon(Icons.lock_open, size: 32),
                                    color: Theme.of(context).primaryColor),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          child: Text(
                            AppLocalizations.of(context)!.askForgotPass,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blueAccent,
                                fontSize: 20 * stateFont.resize),
                          ),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ResetPasswordPage(),
                          )),
                        ),
                        const SizedBox(height: 18),
                        BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, state) {
                            return RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: state.color,
                                      fontSize: 20 * stateFont.resize),
                                  text: appLoc.askHaveNotAccount,
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignUp()),
                                          );
                                        },
                                      text: appLoc.signUp,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blueAccent,
                                          fontSize: 20 * stateFont.resize),
                                    ),
                                  ]),
                            );
                          },
                        ),
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

  Future<void> _authenticateWithEmailAndPassword(context) async {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(emailController.text, passwordController.text),
      );
    }
  }

  void toggleToSignUp(context) {
    BlocProvider.of<AuthBloc>(context).add(UnSignedUpRequested());

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUp()),
    );
  }
}
