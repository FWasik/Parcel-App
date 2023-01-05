import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Reset Password"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthError) {
          Utils.showSnackBar(state.error, Colors.red);
        }
      }, builder: (context, state) {
        if (state is Loading) {
          return CustomCircularProgressIndicator(
              color: Theme.of(context).primaryColor);
        } else {
          return Container(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Type email to reset your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail,
                            color: Theme.of(context).primaryColor),
                        hintText: "Email",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                        )),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? "Enter a valid email"
                            : null,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                      width: 0.7,
                      color: Theme.of(context).primaryColor,
                      icon: const Icon(Icons.email_outlined, size: 32),
                      text: const Text(
                        "Reset Password",
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: () {
                        _resetPassword();
                      }),
                ],
              ),
            ),
          );
        }
      }));

  void _resetPassword() async {
    if (formKey.currentState!.validate()) {
      context
          .read<AuthBloc>()
          .add(ResetUserPasswordRequested(emailController.text));
    }
  }
}
