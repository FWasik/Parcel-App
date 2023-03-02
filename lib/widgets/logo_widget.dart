import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);
  final double size = 280;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
        builder: (contextTheme, stateTheme) {
      return (!stateTheme.isDark
          ? Image.asset(
              "assets/images/logos/parcel_app_logo_black.png",
              width: 250,
              height: 200,
            )
          : Image.asset(
              "assets/images/logos/parcel_app_logo_white.png",
              width: 250,
              height: 200,
            ));
    });
  }
}
