import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:unitrade/utils/connectivity_service.dart';

class FavoriteViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;
  final FirebaseAuth _firebase = FirebaseService.instance.auth;

  bool finishedGets = false;
  bool currentConnection = false;
  List<String> favoriteProducts = [];
  List<ProductModel> productElementList = [];

  FavoriteViewModel() {
    fetchFavoritesData();
    notifyListeners();
  }

  void updateScreen() {
    notifyListeners();
  }

  Future<void> fetchFavoritesData() async {
    try {
      var connectivity = ConnectivityService();
      var hasConnection = await connectivity.checkConnectivity();

      if (!hasConnection) {
        currentConnection = false;
        finishedGets = true;
        notifyListeners();
        return;
      } else {
        currentConnection = true;
        notifyListeners();
      }

      // Fetch favorites
      final favoritesDoc = await _firestore
          .collection('users')
          .doc(_firebase.currentUser?.uid)
          .get();

      if (favoritesDoc.exists) {
        favoriteProducts = List<String>.from(favoritesDoc.data()?['favorites'] ?? []);
      }

      // Fetch products based on favorites
      final QuerySnapshot productsSnapshot = await _firestore.collection('products').get();
      if (productsSnapshot.docs.isNotEmpty) {
        productElementList = productsSnapshot.docs
            .map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return ProductModel(
            id: doc.id,
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            price: double.tryParse(data['price'].toString()) ?? 0.0,
            categories: List<String>.from((data['categories'] ?? []).map((category) {
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
          );
        })
            .where((product) => favoriteProducts.contains(product.id))
            .toList();
      }

    } catch (e) {
      print("Error fetching favorites data: $e");
    } finally {
      finishedGets = true;
      notifyListeners();
    }
  }

}
