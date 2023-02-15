import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
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
  Widget build(BuildContext context) {
    var appLoc = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(AppLocalizations.of(context)!.resetPassword),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
            listener: (contextAuth, stateAuth) {
          if (stateAuth is AuthError) {
            Utils.showSnackBar(stateAuth.error, Colors.red, appLoc.dissmiss);
          }
        }, builder: (contextAuth, stateAuth) {
          if (stateAuth is Loading) {
            return CustomCircularProgressIndicator(
                color: Theme.of(context).primaryColor);
          } else {
            return BlocBuilder<FontBloc, FontState>(
                builder: (contextFont, stateFont) {
              return Container(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appLoc.typeEmail,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 32 * stateFont.resize,
                            fontWeight: FontWeight.w700),
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
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            )),
                        style: TextStyle(fontSize: 16 * stateFont.resize),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? appLoc.validEmail
                                : null,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                          width: 0.7,
                          color: Theme.of(context).primaryColor,
                          icon: const Icon(Icons.email_outlined, size: 32),
                          text: Text(
                            appLoc.resetPassword,
                            style: TextStyle(fontSize: 24 * stateFont.resize),
                          ),
                          onPressed: () {
                            _resetPassword();
                          }),
                    ],
                  ),
                ),
              );
            });
          }
        }));
  }

  void _resetPassword() async {
    if (formKey.currentState!.validate()) {
      context
          .read<AuthBloc>()
          .add(ResetUserPasswordRequested(emailController.text));
    }
  }
}
