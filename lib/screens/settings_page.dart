import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/screens/sign_in.dart';

import 'package:parcel_app/utils/themes.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        return BlocBuilder<FontBloc, FontState>(builder: (context, stateFont) {
          Future.delayed(Duration.zero, () async {
            setState(() {
              _currentSliderValue = stateFont.resize;
            });
          });

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Dark mode",
                      style: TextStyle(fontSize: 22 * stateFont.resize),
                    ),
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, stateTheme) {
                        return Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Switch.adaptive(
                                value: stateTheme.isDark,
                                onChanged: ((value) {
                                  if (stateTheme.isDark) {
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
                                })),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Font size",
                        style: TextStyle(fontSize: 22 * stateFont.resize)),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Slider(
                          value: _currentSliderValue,
                          max: 1.15,
                          min: 0.85,
                          label: _currentSliderValue.toString(),
                          onChanged: (double value) {
                            context.read<FontBloc>().add(FontChangeRequested(
                                  resize: value,
                                ));

                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                if (state is Authenticated)
                  CustomButton(
                      text: Text(
                        "Delete user",
                        style: TextStyle(fontSize: 26 * stateFont.resize),
                      ),
                      color: Colors.red,
                      onPressed: _showDeleteUserDialog,
                      icon: const Icon(
                        Icons.delete,
                        size: 32,
                      ),
                      width: 0.7),
              ]),
            ),
          );
        });
      }),
    );
  }

  Future<void> _showDeleteUserDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocBuilder<FontBloc, FontState>(builder: (context, stateFont) {
          return AlertDialog(
            title: Text('Deleting an account',
                style: TextStyle(fontSize: 24 * stateFont.resize)),
            content: SingleChildScrollView(
              child: Text(
                'Are you sure you want to delete an account?',
                style: TextStyle(fontSize: 18 * stateFont.resize),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel',
                    style: TextStyle(fontSize: 18 * stateFont.resize)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                      color: Colors.red, fontSize: 18 * stateFont.resize),
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(DeleteUserRequested(
                      FirebaseAuth.instance.currentUser!.uid));

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SignIn()),
                      (route) => false);
                },
              ),
            ],
          );
        });
      },
    );
  }
}
