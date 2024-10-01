import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/category_list.dart';
import 'package:unitrade/pages/home/mock_data.dart';
import 'package:unitrade/pages/home/nav_bar.dart';
import 'package:unitrade/pages/home/custom_search_bar.dart';
import 'package:unitrade/pages/home/product_list.dart';

import 'package:unitrade/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var selectedCategory = 'For You';

  var searchValue = '';

  final categoryElementList = MockData.categoryElementList;

  final productElementList = MockData.productList;

  void clickCategory(String category) {
    print('Category: $category');
    setState(() {
      selectedCategory = category;
    });
  }

  void updateSearch(String value) {
    print('Search value: $value');
    setState(() {
      searchValue = value;
    });
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
                  updateSearch,
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

                const SizedBox(
                  height: 20,
                ),

                ProductList(
                  products: productElementList,
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
