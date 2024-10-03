import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/filter_model.dart';

class FilterSectionViewModel extends ChangeNotifier {
  late TextEditingController minPriceController;
  late TextEditingController maxPriceController;
  late TextEditingController minRateController;
  late TextEditingController maxRateController;

  FilterSectionViewModel(FilterModel initialFilters) {
    minPriceController =
        TextEditingController(text: initialFilters.minPrice?.toString());
    maxPriceController =
        TextEditingController(text: initialFilters.maxPrice?.toString());
    minRateController =
        TextEditingController(text: initialFilters.minRate?.toString());
    maxRateController =
        TextEditingController(text: initialFilters.maxRate?.toString());
  }

  void disposeControllers() {
    minPriceController.dispose();
    maxPriceController.dispose();
    minRateController.dispose();
    maxRateController.dispose();
  }

  FilterModel applyFilters() {
    return FilterModel(
      minPrice: double.tryParse(minPriceController.text),
      maxPrice: double.tryParse(maxPriceController.text),
      minRate: double.tryParse(minRateController.text),
      maxRate: double.tryParse(maxRateController.text),
    );
  }

  void clearFilters() {
    minPriceController.clear();
    maxPriceController.clear();
    minRateController.clear();
    maxRateController.clear();
    notifyListeners();
  }
}
