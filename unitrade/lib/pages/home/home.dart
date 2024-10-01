import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/category_list.dart';
import 'package:unitrade/pages/home/nav_bar.dart';
import 'package:unitrade/pages/home/custom_search_bar.dart';

import 'package:unitrade/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

const categoryElementList = [
  'For You',
  'Category 1',
  'Category 2',
  'Category 3',
  'Category 4',
  'Category 5',
];


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var selectedCategory = 'For You';

  void clickCategory(String category) {
    print('Category: $category');
    setState(() {
      selectedCategory = category;
    });
  }

  void searchValue(String value) {
    print('Search value: $value');
  }

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
                  searchValue,
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

                const SizedBox(
                  height: 20,
                ),

                CategoryList(
                  categories: categoryElementList,
                  selectedCategory: selectedCategory,
                  onClick: clickCategory,
                ),

                const SizedBox(
                  height: 20,
                ),

                Text(
                  selectedCategory,
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
