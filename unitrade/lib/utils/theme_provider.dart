import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/utils/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;

  ThemeProvider() {
    _themeData = _getThemeByTime();
    _startTimer();
  }

  ThemeData get themeData => _themeData;

  // TODO: Delete
  void _startTimer() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      _themeData = _getThemeByTime();
      notifyListeners();
    });
  }

  // TODO: Adjust
  ThemeData _getThemeByTime() {
    // final hour = DateTime.now().hour;
    // if (hour < 6 || hour > 18) {
    //   return lightTheme;
    // } else {
    //   return darkTheme;
    // }
    // return lightTheme;
    return darkTheme;
    // return ThemeData();
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(surface: AppColors.primaryNeutral),
  textTheme: GoogleFonts.urbanistTextTheme(
    ThemeData.light().textTheme.copyWith(
          bodyLarge: const TextStyle(color: AppColors.primaryDark),
          bodySmall: const TextStyle(color: AppColors.light400),
          headlineSmall: const TextStyle(color: AppColors.primaryDark),
          headlineLarge: const TextStyle(color: AppColors.primary900),
        ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(surface: AppColors.primaryDark),
  textTheme: GoogleFonts.urbanistTextTheme(
    ThemeData.dark().textTheme.copyWith(
          bodyLarge: const TextStyle(color: AppColors.primaryNeutral),
          bodySmall: const TextStyle(color: AppColors.light400),
          headlineSmall: const TextStyle(color: AppColors.primaryNeutral),
          headlineLarge: const TextStyle(color: AppColors.contrast700),
        ),
  ),
);
