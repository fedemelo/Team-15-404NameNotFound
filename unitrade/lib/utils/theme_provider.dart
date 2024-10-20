import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme modes
enum ThemeModeType { light, dark }

class ThemeProvider extends ChangeNotifier {
  // Variables for time-based theme
  late ThemeData _themeData;
  Timer? _timer;
  int _lastCheckedHour = -1;
  bool _isTimeBased = true;

  // Variables for manual theme
  ThemeModeType _selectedThemeMode = ThemeModeType.light;

  // Constructor
  ThemeProvider() {
    _themeData = lightTheme;
    _loadThemePreference();
    _startListening();
  }

  // Getters
  ThemeData get themeData => _themeData;
  bool get isTimeBased => _isTimeBased;
  ThemeModeType get selectedThemeMode => _selectedThemeMode;

  /* --------- Methods for theme switching --------- */

  void setThemeMode(ThemeModeType mode) {
    _selectedThemeMode = mode;
    _isTimeBased = false;
    _saveThemePreference(getThemeModeString());
    _applyThemeMode();
  }

  String getThemeModeString() {
    if (_selectedThemeMode == ThemeModeType.light) {
      return 'light';
    } else {
      return 'dark';
    }
  }

  Future<void> toggleTimeBasedTheme(bool value) async {
    _isTimeBased = value;
    if (_isTimeBased) {
      await _saveThemePreference(null);
      _initializeByTime();
    } else {
      await _saveThemePreference(getThemeModeString());
      _applyThemeMode();
    }
    notifyListeners();
  }

  void _applyThemeMode() {
    if (_selectedThemeMode == ThemeModeType.light) {
      _themeData = lightTheme;
    } else if (_selectedThemeMode == ThemeModeType.dark) {
      _themeData = darkTheme;
    }
    notifyListeners();
  }

  /* --------- Methods for time-based theme --------- */

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
      if (now.hour != _lastCheckedHour && _isTimeBased) {
        _lastCheckedHour = now.hour;
        _initializeByTime();
      }
    });
  }

  /* --------- Methods for saving/loading theme preference --------- */

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final themePreference = prefs.getString('theme');
    if (kDebugMode) {
      print('Theme preference: $themePreference');
    }

    if (themePreference == null) {
      // If theme is null, it means the user prefers time-based switching
      _isTimeBased = true;
      _initializeByTime();
    } else {
      // Apply the saved manual theme
      _isTimeBased = false;
      if (themePreference == 'light') {
        _selectedThemeMode = ThemeModeType.light;
      } else if (themePreference == 'dark') {
        _selectedThemeMode = ThemeModeType.dark;
      }
      _applyThemeMode();
    }
  }

  Future<void> _saveThemePreference(String? preference) async {
    final prefs = await SharedPreferences.getInstance();
    if (preference == null) {
      await prefs.remove('theme');
    } else {
      await prefs.setString('theme', preference);
    }
  }
}

// Themes
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
          headlineLarge: const TextStyle(color: AppColors.primary600),
        ),
  ),
);
