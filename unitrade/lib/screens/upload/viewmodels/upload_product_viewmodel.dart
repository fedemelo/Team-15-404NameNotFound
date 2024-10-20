import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/screens/upload/models/lease_strategy.dart';
import 'package:unitrade/screens/upload/models/upload_product_strategy.dart';
import 'package:unitrade/screens/upload/models/sale_strategy.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:unitrade/utils/api_config.dart';
import 'package:http/http.dart' as http;

class UploadProductViewModel with ChangeNotifier {
  // Form type
  final String type;
  UploadProductViewModel({required this.type});

  // Strategy
  late final UploadProductStrategy _strategy;

  // Form data
  final formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _price = '';
  String _rentalPeriod = '';
  String _condition = '';

  // Image data
  File? _selectedImage;
  File? get selectedImage => _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String _imageSource = '';

  // Firebase services
  final _user = FirebaseService.instance.auth.currentUser;

  // Loading state
  bool isLoading = false;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImage = File(image.path);
      _imageSource = 'gallery';
      notifyListeners();
    }
  }

  Future<void> takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _selectedImage = File(image.path);
      _imageSource = 'camera';
      notifyListeners();
    }
  }

  void removeImage() {
    _selectedImage = null;
    _imageSource = '';
    notifyListeners();
  }

  void onNameSaved(String? value) {
    _name = value ?? '';
  }

  void onDescriptionSaved(String? value) {
    _description = value ?? '';
  }

  void onPriceSaved(String? value) {
    _price = value ?? '';
  }

  void onConditionSaved(String? value) {
    _condition = value ?? '';
  }

  void onRentalPeriodSaved(String? value) {
    _rentalPeriod = value ?? '';
  }

  Future<List<String>> getCategoriesFromBack(
      String condition, String description, String name, String price) async {
    final body = jsonEncode({
      'condition': condition,
      'description': description,
      'name': name,
      'price': price,
    });

    const headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.put(
        Uri.parse(ApiConfig.apiTestUrl),
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        return List<String>.from(jsonDecode(response.body));
      } else {
        return ["TEXTBOOKS", "CHARGERS"];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ["TEXTBOOKS", "CHARGERS"];
    }
  }

  // Submit the form
  Future<void> submit(BuildContext context) async {
    // First - Validate the form
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    try {
      isLoading = true;
      notifyListeners();

      // Second - Get the categories from the backend
      final categories = await getCategoriesFromBack(
        _condition,
        _description,
        _name,
        _price,
      );

      // Third - Determine the strategy based on the product type
      if (type == 'sale') {
        _strategy = SaleStrategy(
          userId: _user!.uid,
          type: type,
          name: _name,
          description: _description,
          price: _price,
          condition: _condition,
          categories: categories,
          imageUrl: '',
          imageSource: '',
        );
      } else {
        _strategy = LeaseStrategy(
          userId: _user!.uid,
          type: type,
          name: _name,
          description: _description,
          price: _price,
          rentalPeriod: _rentalPeriod,
          condition: _condition,
          categories: categories,
          imageUrl: '',
          imageSource: '',
        );
      }

      // Fourth - If the user has selected an image, upload it to Firebase Storage via the strategy
      if (_selectedImage != null) {
        await _strategy.saveImage(_selectedImage!, _imageSource);
      }

      // Fifth - Save the product data to Firestore via the strategy
      await _strategy.saveProduct();

      // Sixth - Show a success message
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product uploaded successfully')),
      );

      // Seventh - Navigate to the home screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
