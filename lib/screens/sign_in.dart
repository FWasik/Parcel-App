import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parcel_app/bloc/auth_bloc.dart';
import 'package:parcel_app/screens/main_page.dart';
import 'package:parcel_app/screens/reset_password_page.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/screens/sign_up.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';
// import 'package:parcel_app/screens/not_auth/forgot_password_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(child: Text("Sign In")),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainPage()));
          }
          if (state is AuthError) {
            Utils.showSnackBar(state.error, Colors.red);
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return CustomCircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            );
          }
          if (state is UnAuthenticated || state is SignedUp) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 38,
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
                                decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.mail, color: Colors.indigo),
                                    hintText: "Email",
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.indigo, width: 2),
                                    )),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value != null &&
                                          !EmailValidator.validate(value)
                                      ? 'Enter a valid email'
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: passwordController,
                                decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.lock, color: Colors.indigo),
                                    hintText: "Password",
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.indigo, width: 2),
                                    )),
                                obscureText: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value != null && value.length < 6
                                      ? "Enter min. 6 characters"
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                  width: 0.7,
                                  onPressed: () {
                                    _authenticateWithEmailAndPassword(context);
                                  },
                                  text: const Text("Sign In",
                                      style: TextStyle(fontSize: 24)),
                                  icon: const Icon(Icons.lock_open, size: 32),
                                  color: Theme.of(context).primaryColor),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blueAccent,
                              fontSize: 20),
                        ),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResetPasswordPage(),
                        )),
                      ),
                      const SizedBox(height: 18),
                      RichText(
                        text: TextSpan(
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            text: "Do not have an account? ",
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const SignUp()),
                                    );
                                  },
                                text: "Sign up",
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blueAccent),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            );
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
