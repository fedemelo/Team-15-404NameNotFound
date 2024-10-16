import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unitrade/screens/upload/models/upload_product_strategy.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:uuid/uuid.dart';

// Firebase services
final FirebaseStorage _storage = FirebaseService.instance.storage;
final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

class SaleStrategy implements UploadProductStrategy {
  // Form data
  final String userId;
  final String type;
  final String name;
  final String description;
  final String price;
  final String condition;
  final List<String> categories;
  static const reviewCount = 0;
  String? imageUrl;
  String? imageSource;

  SaleStrategy({
    required this.userId,
    required this.type,
    required this.name,
    required this.description,
    required this.price,
    required this.condition,
    required this.categories,
    this.imageUrl,
    this.imageSource,
  });

  @override
  Future<void> saveImage(File selectedImage, String imgSource) async {
    const uuid = Uuid();
    final String fileName = 'images/${uuid.v4()}.jpg';
    await _storage.ref(fileName).putFile(selectedImage);
    final url = await _storage.ref(fileName).getDownloadURL();
    imageUrl = url;
    imageSource = imgSource;
  }

  @override
  Future<void> saveProduct() async {
    final id = const Uuid().v4();
    await _firestore.collection('products').doc(id).set(toMap());
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'type': type,
      'name': name,
      'description': description,
      'price': price,
      'condition': condition,
      'categories': categories,
      'review_count': reviewCount,
      if (imageUrl != null && imageUrl!.isNotEmpty) 'image_url': imageUrl,
      if (imageSource != null && imageSource!.isNotEmpty)
        'image_source': imageSource,
    };
  }
}
