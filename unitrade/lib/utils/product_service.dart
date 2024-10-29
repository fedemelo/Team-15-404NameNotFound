import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/utils/firebase_service.dart';

class ProductService {
  ProductService._privateConstructor();

  static final ProductService instance = ProductService._privateConstructor();

  List<ProductModel>? _products;

  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  List<ProductModel>? get products => _products;

  Future<void> loadProductsInBackground() async {
    _products ??= await fetchProducts();
  }


  Future<List<ProductModel>> fetchProducts() async {
    final QuerySnapshot productsSnapshot = await _firestore.collection('products').get();

    return productsSnapshot.docs.map((doc) {
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
          }),
        ),
        userId: data['user_id'] ?? '',
        type: data['type'] ?? '',
        imageUrl: data['image_url'] ?? '',
        condition: data['condition'] ?? '',
      );
    }).toList();
  }
}
