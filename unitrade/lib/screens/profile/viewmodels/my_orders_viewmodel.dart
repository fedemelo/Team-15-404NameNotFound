import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/utils/connectivity_service.dart';
import 'package:unitrade/utils/firebase_service.dart';

class MyOrdersViewmodel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;
  final FirebaseAuth _firebase = FirebaseService.instance.auth;

  List<ProductModel> products = [];
  bool isLoading = true;
  bool hasConnection = true;

  MyOrdersViewmodel() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      var connectivity = ConnectivityService();
      hasConnection = await connectivity.checkConnectivity();

      if (!hasConnection) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final user = _firebase.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      final String userId = user.uid;

      final QuerySnapshot productsSnapshot =
          await _firestore.collection('products').get();

      if (productsSnapshot.docs.isNotEmpty) {
        products = productsSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return ProductModel(
            id: doc.id,
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            price: double.tryParse(data['price'].toString()) ?? 0.0,
            categories:
                List<String>.from((data['categories'] ?? []).map((category) {
              String lowerCased = category.toLowerCase();
              return '${lowerCased[0].toUpperCase()}${lowerCased.substring(1)}';
            })),
            userId: data['user_id'] ?? '',
            type: data['type'] ?? '',
            imageUrl: data['image_url'] ?? '',
            favoritesForyou: data['favorites_foryou'] ?? 0,
            favoritesCategory: data['favorites_category'] ?? 0,
            favorites: data['favorites'] ?? 0,
            condition: data['condition'] ?? '',
            rentalPeriod: data['rental_period'] ?? '',
            buyer_id: data['buyer_id'] ?? '',
            purchase_date: data['purchase_date'] ?? '',
          );
        })
            .where((product) =>  product.buyer_id == userId)
            .toList();

        print('userId: $userId');
      }
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
