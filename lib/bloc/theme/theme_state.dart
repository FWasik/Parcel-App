part of 'theme_bloc.dart';

class ThemeState {
  final ThemeData? themeData;
  final bool isDark;
  final Color color;
  final Color backgroudBottomBar;

  ThemeState(
      {this.themeData,
      required this.isDark,
      required this.color,
      required this.backgroudBottomBar});
}
