part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ThemeChangeRequested extends ThemeEvent {
  final AppThemes appTheme;
  final bool isDark;
  final Color color;
  final Color backgroundBottomBar;
  final Color checkboxColor;

  ThemeChangeRequested(
      {required this.appTheme,
      required this.isDark,
      required this.color,
      required this.backgroundBottomBar,
      required this.checkboxColor});
}
