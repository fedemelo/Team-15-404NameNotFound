import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/screens/login/models/itempicker_model.dart';
import 'package:unitrade/utils/connectivity_service.dart';

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

  Future<void> submit(BuildContext context) async {


    var connectivity = ConnectivityService();
    var hasConnection = await connectivity.checkConnectivity();
    // If no connection, show a SnackBar and stop the execution
    if (!hasConnection) {
      _itemPickerModel.queueUserCategories(selectedCategories);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No internet connection. User information will be stored and uploaded when connection is available.",
          ),
          duration: Duration(seconds: 3),
        ),
      );
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      });
      return;
    }

    try {
      await _itemPickerModel.updateUserCategories(selectedCategories);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
