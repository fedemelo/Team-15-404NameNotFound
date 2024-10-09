import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/utils/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;
  static const double _brightThreshold = 100.0;

  ThemeProvider() {
    _themeData = lightTheme;
    _initializeLightSensor();
  }

  ThemeData get themeData => _themeData;

  void _initializeLightSensor() async {
    bool hasSensor = await LightSensor.hasSensor();

    if (hasSensor) {
      LightSensor.luxStream().listen((lux) {
        _updateThemeByLightLevel(lux);
      });
    } else {
      if (kDebugMode) {
        print("Device doesn't have a light sensor.");
      }
    }
  }

  void _updateThemeByLightLevel(int lux) {
    if (lux > _brightThreshold && _themeData != lightTheme) {
      _themeData = lightTheme;
      notifyListeners();
    } else if (lux <= _brightThreshold && _themeData != darkTheme) {
      _themeData = darkTheme;
      notifyListeners();
    }
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
