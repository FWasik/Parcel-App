import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/models/custom_user.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is Authenticated) {
          CustomUser? user = state.user!;
          var appLoc = AppLocalizations.of(context)!;

          return BlocBuilder<FontBloc, FontState>(
              builder: (context, stateFont) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FlutterLogo(
                        size: 150,
                      ),
                      const SizedBox(height: 20),
                      Text(appLoc.welcome,
                          style: TextStyle(fontSize: 38 * stateFont.resize),
                          maxLines: 2,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 30),
                      Text(
                        appLoc.logAs,
                        style: TextStyle(fontSize: 24 * stateFont.resize),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.fullName,
                        style: TextStyle(
                            fontSize: 26 * stateFont.resize,
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        appLoc.optionsBelow,
                        style: TextStyle(fontSize: 24 * stateFont.resize),
                      ),
                      const SizedBox(height: 60),
                      const Icon(Icons.keyboard_double_arrow_down, size: 80)
                    ]),
              ),
            );
          });
        } else {
          return Container();
        }
      }),
    );
  }
}
