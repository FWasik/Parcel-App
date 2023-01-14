import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parcel_app/bloc/language/language_bloc.dart';

import 'package:parcel_app/utils/themes.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/utils/delete_dialogs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    var appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.settings),
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
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          appLoc.darkMode,
                          style: TextStyle(fontSize: 20 * stateFont.resize),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, stateTheme) {
                        return Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
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
                  children: [
                    Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(appLoc.fontSize,
                              style:
                                  TextStyle(fontSize: 20 * stateFont.resize))),
                    ),
                    Slider(
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
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          appLoc.language,
                          style: TextStyle(fontSize: 20 * stateFont.resize),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text(
                            appLoc.setEnglish,
                            style: TextStyle(fontSize: 18 * stateFont.resize),
                          ),
                          onPressed: () {
                            context
                                .read<LanguageBloc>()
                                .add(LanguageChangeRequested(
                                  language: "en",
                                ));
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text(appLoc.setPolish,
                              style:
                                  TextStyle(fontSize: 18 * stateFont.resize)),
                          onPressed: () {
                            context
                                .read<LanguageBloc>()
                                .add(LanguageChangeRequested(
                                  language: "pl",
                                ));
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
                        appLoc.deleteUserButton,
                        style: TextStyle(fontSize: 26 * stateFont.resize),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        DeleteDialogs.showDeleteUserDialog(context);
                      },
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
}