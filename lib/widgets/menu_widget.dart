import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/bloc/auth/auth_bloc.dart';

import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/screens/settings_page.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return BlocBuilder<FontBloc, FontState>(builder: (context, stateFont) {
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
                        "Settings",
                        style: TextStyle(fontSize: 16 * stateFont.resize),
                      )
                    ])),
            if (state is Authenticated)
              PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.logout, color: Theme.of(context).primaryColor),
                      Text("Sign out",
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
