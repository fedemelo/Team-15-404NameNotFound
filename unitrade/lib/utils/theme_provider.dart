import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/utils/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;
  static const double _brightThreshold = 100.0;
  Timer? _timer;
  int _lastCheckedHour = -1;

  ThemeProvider() {
    // Default theme
    _themeData = lightTheme;

    // Light sensor
    // _initializeLightSensor();

    // Time based theme
    _initializeByTime();
    _startListening();
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

  void _initializeByTime() {
    final hour = DateTime.now().hour;
    final newTheme = (hour >= 6 && hour < 18) ? lightTheme : darkTheme;
    if (newTheme != _themeData) {
      _themeData = newTheme;
      notifyListeners();
    }
  }

  void _startListening() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      final now = DateTime.now();
      if (now.hour != _lastCheckedHour) {
        _lastCheckedHour = now.hour;
        _initializeByTime();
      }
    });
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
