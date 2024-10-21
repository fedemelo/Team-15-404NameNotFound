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
    ThemeModeType? selectedThemeMode = _viewModel.selectedThemeMode;

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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            Text(
              "Appearance",
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headlineLarge!.color,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color.fromARGB(255, 246, 246, 246)
                    : const Color.fromARGB(255, 17, 17, 17),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.wb_sunny, size: 60),
                      Radio<ThemeModeType>(
                        value: ThemeModeType.light,
                        groupValue: isTimeBased
                            ? null
                            : selectedThemeMode, // Radio button deselected when switch is on
                        activeColor: AppColors.primary900,
                        onChanged: (ThemeModeType? value) {
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
                      const Icon(Icons.nights_stay, size: 60),
                      Radio<ThemeModeType>(
                        value: ThemeModeType.dark,
                        groupValue: isTimeBased
                            ? null
                            : selectedThemeMode, // Radio button deselected when switch is on
                        activeColor: AppColors.primary900,
                        onChanged: (ThemeModeType? value) {
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
            ),
            const SizedBox(height: 30),

            // Automatic Settings Section
            Text(
              "Automatic Settings",
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headlineLarge!.color,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color.fromARGB(255, 246, 246, 246)
                    : const Color.fromARGB(255, 17, 17, 17),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Automatic time-aware",
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: isTimeBased
                          ? Theme.of(context).textTheme.bodyLarge!.color
                          : AppColors.light400,
                    ),
                  ),
                  Switch(
                    value: isTimeBased,
                    onChanged: (bool value) {
                      setState(() {
                        _viewModel.toggleTimeBasedTheme(value);
                      });
                    },
                    activeColor: AppColors.primary900,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
