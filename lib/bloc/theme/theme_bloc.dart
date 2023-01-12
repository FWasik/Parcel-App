import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:parcel_app/utils/themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(
            themeData: appThemeData[AppThemes.dark],
            isDark: true,
            color: Colors.white,
            backgroudBottomBar: const Color.fromARGB(255, 49, 51, 62))) {
    on<ThemeChangeRequested>(((event, emit) async {
      emit(ThemeState(
          themeData: appThemeData[event.appTheme],
          isDark: event.isDark,
          color: event.color,
          backgroudBottomBar: event.backgroundBottomBar));
    }));
  }
}
