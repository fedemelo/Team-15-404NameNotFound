import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/view/category_list_view.dart';
import 'package:unitrade/pages/home/mock_data.dart';
import 'package:unitrade/pages/home/view/nav_bar_view.dart';
import 'package:unitrade/pages/home/view/custom_search_bar_view.dart';
import 'package:unitrade/pages/home/models/product_model.dart';
import 'package:unitrade/pages/home/view/product_list_view.dart';
import 'package:unitrade/pages/home/models/filter_model.dart';
import 'package:unitrade/pages/home/view/filter_section_view.dart';
import 'package:unitrade/pages/home/viewmodels/filter_viewmodel.dart';

import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var selectedCategory = 'For You';

  var searchValue = '';

  FilterModel filters = FilterModel();

  final categoryElementList = MockData.categoryElementList;

  final productElementList = MockData.productList;

  List<ProductModel> filteredProducts = [];

  void _filterProducts() {
    setState(() {
      filteredProducts = FilterViewModel.filterProducts(
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

  void updateFilters(FilterModel newFilters) {
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
        return FilterSectionView(
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
                CustomSearchBarView(
                  onChange: updateSearch,
                  onClickFilter: _showFilterWidget,
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
                CategoryListView(
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
                ProductListView(
                  products: filteredProducts,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBarView(),
    );
  }
}
