import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/utils/connectivity_service.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyOrdersViewmodel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;
  final FirebaseAuth _firebase = FirebaseService.instance.auth;

  List<ProductModel> products = [];
  bool isLoading = true;
  bool hasConnection = true;
  bool isOfflineData = false;

  MyOrdersViewmodel() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading = true;
    isOfflineData = false;
    notifyListeners();
    try {
      var connectivity = ConnectivityService();
      hasConnection = await connectivity.checkConnectivity();

      if (hasConnection) {
        await _fetchProductsFromFirebase();
      } else {
        isOfflineData = true;
        await fetchProductsFromHive();
      }
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchProductsFromFirebase() async {
    try {
      final user = _firebase.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      final String userId = user.uid;

      final QuerySnapshot productsSnapshot =
          await _firestore.collection('products').get();

      products = productsSnapshot.docs
          .map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return ProductModel(
              id: doc.id,
              name: data['name'] ?? '',
              description: data['description'] ?? '',
              price: double.tryParse(data['price'].toString()) ?? 0.0,
              categories: List<String>.from(data['categories'] ?? []),
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
          .where((product) => product.buyer_id == userId)
          .toList();

      // Save products to Hive in the background
      await saveProductsToHive(products);
    } catch (e) {
      print("Error fetching products from Firebase: $e");
    }
  }

  Future<void> fetchProductsFromHive() async {
    try {
      print("Fetching products from Hive");
      final box = await Hive.openBox('myOrders');
      final storedProducts =
          box.get('products', defaultValue: <ProductModel>[]);
      if (storedProducts is List<ProductModel>) {
        products = storedProducts;
      } else {
        products = [];
      }
      print("Products fetched from Hive");
      print(products);
    } catch (e) {
      print("Error fetching products from Hive: $e");
      products = [];
    }
  }

  Future<void> saveProductsToHive(List<ProductModel> products) async {
    try {
      print("Saving products to Hive");
      final box = await Hive.openBox('myOrders');
      await box.put('products', products);
      print("Products saved to Hive");
    } catch (e) {
      print("Error saving products to Hive: $e");
    }
  }
}
