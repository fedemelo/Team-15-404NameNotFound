import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/filter_model.dart';

class FilterSectionViewModel extends ChangeNotifier {
  late TextEditingController minPriceController;
  late TextEditingController maxPriceController;
  String sortBy = '';
  bool sortAscendant = true;
  bool invalidPriceRange = false;
  bool missingPriceFields = false;

  FilterSectionViewModel(FilterModel initialFilters) {
    minPriceController =
        TextEditingController(text: initialFilters.minPrice?.toString());
    maxPriceController =
        TextEditingController(text: initialFilters.maxPrice?.toString());
    sortBy = initialFilters.sortBy ?? 'Rating';
    sortAscendant = initialFilters.sortAscendant;

    minPriceController.addListener(_validatePriceRange);
    maxPriceController.addListener(_validatePriceRange);
  }

  void disposeControllers() {
    minPriceController.dispose();
    maxPriceController.dispose();
  }

  FilterModel applyFilters() {
    return FilterModel(
      minPrice: double.tryParse(minPriceController.text),
      maxPrice: double.tryParse(maxPriceController.text),
      sortBy: sortBy,
      sortAscendant: sortAscendant,
    );
  }

  void clearFilters() {
    minPriceController.clear();
    maxPriceController.clear();
    sortBy = '';
    sortAscendant = true;
    invalidPriceRange = false;
    missingPriceFields = false;
    notifyListeners();
  }

  void updateSortBy(String newSortBy) {
    sortBy = newSortBy;
    notifyListeners();
  }

  void updateSortOrder(bool isAscendant) {
    sortAscendant = isAscendant;
    notifyListeners();
  }

  void _validatePriceRange() {
    final minPrice = double.tryParse(minPriceController.text);
    final maxPrice = double.tryParse(maxPriceController.text);

    if ((minPriceController.text.isNotEmpty && maxPriceController.text.isEmpty) ||
        (minPriceController.text.isEmpty && maxPriceController.text.isNotEmpty)) {
      missingPriceFields = true;
    } else {
      missingPriceFields = false;
    }


    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
      invalidPriceRange = true;
    } else {
      invalidPriceRange = false;
    }

    notifyListeners();
  }
}
