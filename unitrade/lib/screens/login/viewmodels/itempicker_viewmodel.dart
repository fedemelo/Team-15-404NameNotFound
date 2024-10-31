import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/screens/login/models/itempicker_model.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:unitrade/utils/connectivity_service.dart';

class ItemPickerViewModel extends ChangeNotifier {
  final ItemPickerModel _itemPickerModel = ItemPickerModel();

  List<String> _categories = [];
  List<String> selectedCategories = [];
  final List<String> _semesters = ['1-2', '3-4', '5-6', '7-8', '9-10', '+10'];
  String _selectedSemester = "1-2";
  List<String> _majors = [];
  String? _selectedMajor;
  bool isLoading = true;
  String? errorMessage;

  List<String> get categories => _categories;
  List<String> get majors => _majors;
  List<String> get semesters => _semesters;
  String get selectedSemester => _selectedSemester;
  String? get selectedMajor => _selectedMajor;

  ItemPickerViewModel() {
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await fetchCategories();
    await fetchMajors();

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await _itemPickerModel.fetchCategories();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMajors() async {
    try {
      _majors = await _itemPickerModel.fetchMajors();
    } catch (e) {
      errorMessage = e.toString();
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

  void setSemester(String semester) {
    _selectedSemester = semester;
    notifyListeners();
  }

  void setMajor(String? major) {
    _selectedMajor = major;
    notifyListeners();
  }

  bool validateSelections() {
    return _selectedMajor != null && _selectedMajor!.isNotEmpty;
  }

  Future<void> submit(BuildContext context) async {
    if (!validateSelections()) {
      errorMessage = "Please select a major.";
      notifyListeners();
      return;
    }
    var connectivity = ConnectivityService();
    var hasConnection = await connectivity.checkConnectivity();
    if (!hasConnection) {
      _itemPickerModel.queueUserInformation(
          selectedCategories, _selectedMajor!, _selectedSemester);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No internet connection. User information will be stored and uploaded when connection is available.",
            style: TextStyle(color: AppColors.primaryNeutral),
          ),
          duration: Duration(seconds: 3),
          showCloseIcon: true,
          closeIconColor: AppColors.primaryNeutral,
          backgroundColor: AppColors.danger,
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
      await _itemPickerModel.updateUserInformation(
          selectedCategories, _selectedMajor!, _selectedSemester);
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
