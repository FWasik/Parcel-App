import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/screens/settings_page.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appLoc = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(builder: (contextAuth, stateAuth) {
      return BlocBuilder<FontBloc, FontState>(
          builder: (contextFont, stateFont) {
        return PopupMenuButton(itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
                value: 1,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.settings,
                          color: Theme.of(context).primaryColor),
                      Text(
                        appLoc.settings,
                        style: TextStyle(fontSize: 16 * stateFont.resize),
                      )
                    ])),
            if (stateAuth is Authenticated)
              PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.logout, color: Theme.of(context).primaryColor),
                      Text(appLoc.signOut,
                          style: TextStyle(fontSize: 16 * stateFont.resize))
                    ],
                  )),
          ];
        }, onSelected: (value) {
          if (value == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ));
          } else if (value == 2) {
            context.read<AuthBloc>().add(SignOutRequested());
          }
        });
      });
    });
  }
}
