import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/screens/sign_in.dart';

import 'package:parcel_app/utils/themes.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/models/custom_user.dart';
import 'package:parcel_app/widgets/button_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is Authenticated) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Dark mode",
                      style: TextStyle(fontSize: 20),
                    ),
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, state) {
                        return Switch.adaptive(
                            value: state.isDark,
                            onChanged: ((value) {
                              if (state.isDark) {
                                context.read<ThemeBloc>().add(
                                    ThemeChangeRequested(
                                        appTheme: AppThemes.light,
                                        isDark: false,
                                        color: Colors.black,
                                        backgroundBottomBar:
                                            const Color.fromARGB(
                                                251, 232, 224, 224)));
                              } else {
                                context.read<ThemeBloc>().add(
                                    ThemeChangeRequested(
                                        appTheme: AppThemes.dark,
                                        isDark: true,
                                        color: Colors.white,
                                        backgroundBottomBar:
                                            const Color.fromARGB(
                                                255, 49, 51, 62)));
                              }
                            }));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                CustomButton(
                    text: const Text(
                      "Delete user",
                      style: TextStyle(fontSize: 24),
                    ),
                    color: Colors.red,
                    onPressed: _showDeleteUserDialog,
                    icon: const Icon(
                      Icons.delete,
                      size: 32,
                    ),
                    width: 0.5)
              ]),
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }

  Future<void> _showDeleteUserDialog() async {
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

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignIn()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
