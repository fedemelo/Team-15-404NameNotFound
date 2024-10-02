import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/category_list.dart';
import 'package:unitrade/pages/home/mock_data.dart';
import 'package:unitrade/pages/home/nav_bar.dart';
import 'package:unitrade/pages/home/custom_search_bar.dart';
import 'package:unitrade/pages/home/product.dart';
import 'package:unitrade/pages/home/product_list.dart';
import 'package:unitrade/pages/home/filter.dart';
import 'package:unitrade/pages/home/filter_widget.dart';
import 'package:unitrade/pages/home/filter_logic.dart';

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

  Filters filters = Filters();

  final categoryElementList = MockData.categoryElementList;

  final productElementList = MockData.productList;

  List<Product> filteredProducts = [];

  void _filterProducts() {
    setState(() {
      filteredProducts = FilterLogic.filterProducts(
        allProducts: productElementList,
        selectedCategory: selectedCategory,
        searchQuery: searchValue,
        filters: filters,
        userCategories: MockData.userCategories,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _filterProducts();
  }

  void clickCategory(String category) {
    print('Category: $category');
    setState(() {
      selectedCategory = category;
      searchValue = '';
      _filterProducts();
    });
  }

  void updateSearch(String value) {
    print('Search value: $value');
    setState(() {
      searchValue = value;
      selectedCategory = '';
      _filterProducts();
    });
  }

  void updateFilters(Filters newFilters) {
    print('Filters: $newFilters');
    setState(() {
      filters = newFilters;
      _filterProducts();
    });
  }

  void _showFilterWidget() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterWidget(
          actualFilters: filters,
          onUpdateFilters: updateFilters,
        );
      },
    );
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
                  _showFilterWidget,
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
                  products: filteredProducts,
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

