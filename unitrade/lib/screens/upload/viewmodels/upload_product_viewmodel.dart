import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/screens/upload/models/lease_strategy.dart';
import 'package:unitrade/screens/upload/models/upload_product_strategy.dart';
import 'package:unitrade/screens/upload/models/sale_strategy.dart';

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
  final _user = FirebaseAuth.instance.currentUser;

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

  // Submit the form
  Future<void> submit(BuildContext context) async {
    // First - Validate the form
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    try {
      // Second - Determine the strategy based on the product type
      if (type == 'sale') {
        _strategy = SaleStrategy(
          userId: _user!.uid,
          type: type,
          name: _name,
          description: _description,
          price: _price,
          condition: _condition,
          categories: ['TEXTBOOKS', 'CHARGERS'],
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
          categories: ['TEXTBOOKS', 'CHARGERS'],
          imageUrl: '',
          imageSource: '',
        );
      }

      // Third - If the user has selected an image, upload it to Firebase Storage via the strategy
      if (_selectedImage != null) {
        await _strategy.saveImage(_selectedImage!, _imageSource);
      }

      // Fourth - Save the product data to Firestore via the strategy
      await _strategy.saveProduct();

      // Fifth - Show a success message
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product uploaded successfully')),
      );

      // Sixth - Navigate to the home screen
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
