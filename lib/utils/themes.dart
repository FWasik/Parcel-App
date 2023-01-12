import 'package:flutter/material.dart';

enum AppThemes { dark, light }

final appThemeData = {
  AppThemes.dark:
      ThemeData(brightness: Brightness.dark, primaryColor: Colors.indigo),
  AppThemes.light:
      ThemeData(brightness: Brightness.light, primaryColor: Colors.amber)
};
