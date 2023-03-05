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
    var orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var themeSpacer = orientation ? 2 : 3;
    var lanSpacer = orientation ? 3 : 4;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.settings),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (contextAuth, stateAuth) {
        return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, stateTheme) {
          return BlocBuilder<FontBloc, FontState>(
              builder: (contextFont, stateFont) {
            Future.delayed(Duration.zero, () async {
              setState(() {
                _currentSliderValue = stateFont.resize;
              });
            });

            return Column(children: [
              if (stateAuth is Authenticated)
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: CustomButton(
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
                ),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.only(top: 30.0),
                  childAspectRatio: MediaQuery.of(context).size.height / 300,
                  crossAxisCount: 2,
                  children: <Widget>[
                    Center(
                      child: Text(appLoc.fontSize,
                          style: TextStyle(fontSize: 20 * stateFont.resize)),
                    ),
                    Center(
                      child: Switch.adaptive(
                          activeColor: stateTheme.checkboxColor,
                          value: stateTheme.isDark,
                          onChanged: ((value) {
                            if (stateTheme.isDark) {
                              context.read<ThemeBloc>().add(
                                  ThemeChangeRequested(
                                      appTheme: AppThemes.light,
                                      isDark: false,
                                      color: Colors.black,
                                      backgroundBottomBar: const Color.fromARGB(
                                          251, 232, 224, 224),
                                      checkboxColor: Colors.black));
                            } else {
                              context.read<ThemeBloc>().add(
                                  ThemeChangeRequested(
                                      appTheme: AppThemes.dark,
                                      isDark: true,
                                      color: Colors.white,
                                      backgroundBottomBar:
                                          const Color.fromARGB(255, 49, 51, 62),
                                      checkboxColor: Colors.indigo));
                            }
                          })),
                    ),
                    Center(
                      child: Text(
                        appLoc.darkMode,
                        style: TextStyle(fontSize: 20 * stateFont.resize),
                      ),
                    ),
                    Center(
                      child: Slider(
                        activeColor: stateTheme.checkboxColor,
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
                    Center(
                      child: Text(
                        appLoc.language,
                        style: TextStyle(fontSize: 20 * stateFont.resize),
                      ),
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          child: Text(
                            appLoc.setEnglish,
                            style: TextStyle(
                                fontSize: 18 * stateFont.resize,
                                color: stateTheme.checkboxColor),
                          ),
                          onPressed: () {
                            context
                                .read<LanguageBloc>()
                                .add(LanguageChangeRequested(
                                  language: "en",
                                ));
                          },
                        ),
                        TextButton(
                          child: Text(appLoc.setPolish,
                              style: TextStyle(
                                  fontSize: 18 * stateFont.resize,
                                  color: stateTheme.checkboxColor)),
                          onPressed: () {
                            context
                                .read<LanguageBloc>()
                                .add(LanguageChangeRequested(
                                  language: "pl",
                                ));
                          },
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ]);
          });
        });
      }),
    );
  }
}
