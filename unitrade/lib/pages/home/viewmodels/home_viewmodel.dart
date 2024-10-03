import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/models/product_model.dart';
import 'package:unitrade/pages/home/models/filter_model.dart';
import 'package:unitrade/pages/home/mock_data.dart';
import 'package:unitrade/pages/home/viewmodels/filter_viewmodel.dart';

class HomeViewModel extends ChangeNotifier {
  String selectedCategory = 'For You';
  String searchValue = '';
  FilterModel filters = FilterModel();

  final List<String> categoryElementList = MockData.categoryElementList;
  final List<ProductModel> productElementList = MockData.productList;

  List<ProductModel> filteredProducts = [];

  HomeViewModel() {
    _filterProducts();
  }

  void _filterProducts() {
    filteredProducts = FilterViewModel.filterProducts(
      allProducts: productElementList,
      selectedCategory: selectedCategory,
      searchQuery: searchValue,
      filters: filters,
      userCategories: MockData.userCategories,
    );
    notifyListeners(); // Notifica a la vista cuando hay cambios
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
}
