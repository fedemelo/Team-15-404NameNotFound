import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/home/models/filter_model.dart';
import 'package:unitrade/screens/home/mock_data.dart';
import 'package:unitrade/screens/home/viewmodels/filter_viewmodel.dart';
import 'package:unitrade/screens/home/views/filter_section_view.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel extends ChangeNotifier {
  String selectedCategory = 'For You';
  String searchValue = '';
  FilterModel filters = FilterModel();

  List<String> categoryElementList = [];
  final List<ProductModel> productElementList = MockData.productList;

  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  List<ProductModel> filteredProducts = [];

  HomeViewModel() {
    fetchCategories();
    _filterProducts();
  }

  void showFilterWidget(BuildContext context, HomeViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterSectionView(
          actualFilters: viewModel.filters,
          onUpdateFilters: viewModel.updateFilters,
        );
      },
    );
  }

  void _filterProducts() {
    filteredProducts = FilterViewModel.filterProducts(
      allProducts: productElementList,
      selectedCategory: selectedCategory,
      searchQuery: searchValue,
      filters: filters,
      userCategories: MockData.userCategories,
    );
    notifyListeners();
  }

  void clickCategory(String category) {
    selectedCategory = category;
    searchValue = '';
    _filterProducts();
  }

  void updateSearch(String value) {
    searchValue = value;
    selectedCategory = '';
    _filterProducts();
  }

  void updateFilters(FilterModel newFilters) {
    filters = newFilters;
    _filterProducts();
  }

  Future<void> fetchCategories() async {
    final categoriesDoc = await _firestore
        .collection('categories')
        .doc('all')
        .get();

    if (categoriesDoc.exists) {
      List<dynamic> categories = categoriesDoc.data()?['names'] ?? [];

      categoryElementList = List<String>.from(categories.map((category) {
        String lowerCased = category.toLowerCase();
        return '${lowerCased[0].toUpperCase()}${lowerCased.substring(1)}';
      }));

      categoryElementList.insert(0, 'For You');

      _filterProducts();
    } else {
      throw Exception("Categories not found");
    }
  }

}
