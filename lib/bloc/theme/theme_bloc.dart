import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:parcel_app/utils/themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
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

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
    ThemeData? theme;
    bool isDark = json["isDark"];

    if (isDark) {
      theme = appThemeData[AppThemes.dark];
    } else {
      theme = appThemeData[AppThemes.light];
    }

    return ThemeState(
        themeData: theme,
        isDark: isDark,
        color: Color(json["color"]),
        backgroudBottomBar: Color(json["backgroundBottomBar"]));
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) => {
        "isDark": state.isDark,
        "color": state.color.value,
        "backgroundBottomBar": state.backgroudBottomBar.value
      };
}
