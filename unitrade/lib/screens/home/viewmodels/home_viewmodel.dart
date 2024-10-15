import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/home/models/filter_model.dart';
import 'package:unitrade/screens/home/viewmodels/filter_viewmodel.dart';
import 'package:unitrade/screens/home/views/filter_section_view.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeViewModel extends ChangeNotifier {
  String selectedCategory = 'For You';
  String searchValue = '';
  FilterModel filters = FilterModel();

  bool finishedGets = false;
  bool selectedFilters = false;

  List<String> categoryElementList = [];
  List<String> categoryUserList = [];
  List<ProductModel> productElementList = [];

  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;
  final FirebaseAuth _firebase = FirebaseService.instance.auth;

  List<ProductModel> filteredProducts = [];

  HomeViewModel() {
    fetchAllData();
    _filterProducts();
  }

  void updateFilterColor(bool filter){
    selectedFilters = filter;
    notifyListeners();
  }

  void showFilterWidget(BuildContext context, HomeViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterSectionView(
          actualFilters: viewModel.filters,
          onUpdateFilters: viewModel.updateFilters,
          selectedFilters: updateFilterColor,
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
      userCategories: categoryUserList,
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

    } else {
      throw Exception("Categories not found");
    }
  }

  Future<void> fetchUserCategories() async {
    final categoriesDoc = await _firestore
        .collection('users')
        .doc(_firebase.currentUser?.uid)
        .get();

    if (categoriesDoc.exists) {
      List<dynamic> categories = categoriesDoc.data()?['categories'] ?? [];

      categoryUserList = List<String>.from(categories.map((category) {
        String lowerCased = category.toLowerCase();
        return '${lowerCased[0].toUpperCase()}${lowerCased.substring(1)}';
      }));

    } else {
      categoryUserList = ["TEXTBOOKS", "ELECTRONICS"];
    }
  }

  Future<void> fetchProducts() async {
    final QuerySnapshot productsSnapshot = await _firestore
        .collection('products')
        .get();

    if (productsSnapshot.docs.isNotEmpty) {
      List<ProductModel> products = productsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ProductModel(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: double.tryParse(data['price'].toString()) ?? 0.0,
          categories: List<String>.from(
              (data['categories'] ?? []).map((category) {
                String lowerCased = category.toLowerCase();
                return '${lowerCased[0].toUpperCase()}${lowerCased.substring(1)}';
              })
          ),
          userId: data['user_id'] ?? '',
          type: data['type'] ?? '',
          imageUrl: data['image_url'] ?? '',
          condition: data['condition'] ?? '',
        );
      }).toList();

      productElementList = products;
    } else {
      throw Exception("No products found");
    }
  }

  Future<void> fetchAllData() async {
    try {
      await Future.wait([
        fetchCategories(),
        fetchUserCategories(),
        fetchProducts(),
      ]);

      finishedGets = true;
      _filterProducts();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

}
