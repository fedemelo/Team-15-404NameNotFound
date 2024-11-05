import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/utils/theme_provider.dart';

class ThemeViewModel {
  final BuildContext context;
  ThemeViewModel(this.context);

  ThemeModeType get selectedThemeMode =>
      Provider.of<ThemeProvider>(context, listen: false).selectedThemeMode;

  bool get isTimeBased =>
      Provider.of<ThemeProvider>(context, listen: false).isTimeBased;

  void setThemeMode(ThemeModeType mode) {
    Provider.of<ThemeProvider>(context, listen: false).setThemeMode(mode);
  }

  void toggleTimeBasedTheme(bool value) {
    Provider.of<ThemeProvider>(context, listen: false)
        .toggleTimeBasedTheme(value);
  }
}
