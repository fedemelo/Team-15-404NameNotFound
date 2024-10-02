import 'package:flutter/material.dart';
import 'package:unitrade/pages/login/models/itempicker_model.dart';

class ItemPickerViewModel extends ChangeNotifier {
  final ItemPickerModel _itemPickerModel = ItemPickerModel();

  List<String> _categories = [];
  List<String> selectedCategories = [];
  bool isLoading = true;
  String? errorMessage;

  List<String> get categories => _categories;

    ItemPickerViewModel() {
    fetchCategories(); 
  }

  Future<void> fetchCategories() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      _categories = await _itemPickerModel.fetchCategories();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    notifyListeners();
  }

  Future<void> submit() async {
    try {
      await _itemPickerModel.updateUserCategories(selectedCategories);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
