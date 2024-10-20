import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/screens/profile/viewmodels/theme_viewmodel.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:unitrade/utils/theme_provider.dart';

class ThemeView extends StatefulWidget {
  const ThemeView({super.key});

  @override
  ThemeViewState createState() => ThemeViewState();
}

class ThemeViewState extends State<ThemeView> {
  late ThemeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ThemeViewModel(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isTimeBased = _viewModel.isTimeBased;

    return Scaffold(
      bottomNavigationBar: const NavBarView(initialIndex: 4),
      appBar: AppBar(
        elevation: 1.0,
        title: Text(
          'Theme Settings',
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Choose Theme Mode"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.wb_sunny, size: 40),
                    Radio<ThemeModeType>(
                      value: ThemeModeType.light,
                      groupValue: _viewModel.selectedThemeMode,
                      onChanged: isTimeBased
                          ? null // Disable when time-based is ON
                          : (ThemeModeType? value) {
                              if (value != null) {
                                _viewModel.setThemeMode(value);
                                setState(() {});
                              }
                            },
                    ),
                    const Text("Light"),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.nights_stay, size: 40),
                    Radio<ThemeModeType>(
                      value: ThemeModeType.dark,
                      groupValue: _viewModel.selectedThemeMode,
                      onChanged: isTimeBased
                          ? null // Disable when time-based is ON
                          : (ThemeModeType? value) {
                              if (value != null) {
                                _viewModel.setThemeMode(value);
                                setState(() {});
                              }
                            },
                    ),
                    const Text("Dark"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Automatic time-aware (Sunrise/Sunset)",
                  style: GoogleFonts.urbanist(
                    color: isTimeBased
                        ? Theme.of(context).textTheme.bodyLarge!.color
                        : AppColors.light400,
                  ),
                ),
                Switch(
                  value: isTimeBased,
                  onChanged: (bool value) {
                    _viewModel.toggleTimeBasedTheme(value);
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
