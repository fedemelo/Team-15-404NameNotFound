import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/nav_bar.dart';
import 'package:unitrade/pages/home/custom_search_bar.dart';

import 'package:unitrade/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  void searchValue(String value) {
    print('Search value: $value');
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),

                CustomSearchBar(
                  widget.searchValue,
                ),

                const SizedBox(
                  height: 20,
                ),

                Text(
                  'Categories',
                  style: GoogleFonts.urbanist(
                      fontSize: 20,
                      color: AppColors.primary900,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
