import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unitrade/pages/home/home.dart';
import 'package:unitrade/pages/upload/models/sale_model.dart';
import 'package:uuid/uuid.dart';

class SaleViewModel with ChangeNotifier {
  // Form data
  final formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _price = '';
  String _condition = '';
  String _imageUrl = '';

  // Image data
  File? _selectedImage;
  File? get selectedImage => _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Firebase services
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImage = File(image.path);
      notifyListeners();
    }
  }

  Future<void> takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _selectedImage = File(image.path);
      notifyListeners();
    }
  }

  void removeImage() {
    _selectedImage = null;
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

  // Submit the form
  Future<void> submit(BuildContext context) async {
    // First - Validate the form
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    try {
      // Second - If the user has selected an image, upload it to Firebase Storage
      if (_selectedImage != null) {
        const uuid = Uuid();
        final String fileName = 'images/${uuid.v4()}.jpg';
        await _storage.ref(fileName).putFile(_selectedImage!);
        _imageUrl = await _storage.ref(fileName).getDownloadURL();
      }

      // Third - Create a new SaleModel instance and upload it to Firestore
      final sale = SaleModel(
        userId: _user!.uid,
        type: 'sale',
        name: _name,
        description: _description,
        price: _price,
        condition: _condition,
        categories: ['TEXTBOOKS', 'CHARGERS'],
        imageUrl: _imageUrl,
      );

      final id = const Uuid().v4();
      await _firestore.collection('products').doc(id).set(sale.toMap());

      // Fourth - Show a success message
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product uploaded successfully')),
      );

      // Fifth - Navigate to the home page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
