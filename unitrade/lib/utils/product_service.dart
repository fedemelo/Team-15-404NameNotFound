import 'dart:async';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unitrade/utils/firebase_options.dart';

class ProductService {
  ProductService._privateConstructor();

  static final ProductService instance = ProductService._privateConstructor();

  List<ProductModel>? _products;

  List<ProductModel>? get products => _products;

  Future<void> loadProductsInBackground() async {
    try {
    if (_products == null) {
      final receivePort = ReceivePort();
      final rootIsolateToken = RootIsolateToken.instance;

      if (rootIsolateToken != null) {
        await Isolate.spawn(
            _fetchProductsInIsolate, [receivePort.sendPort, rootIsolateToken]);
      } else {
        print("Error: RootIsolateToken es null.");
        return;
      }

      final completer = Completer<List<ProductModel>>();
      receivePort.listen((data) {
        completer.complete(data as List<ProductModel>);
      });

      _products = await completer.future;

      }
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  static Future<void> _fetchProductsInIsolate(List<dynamic> args) async {
    try {
      final SendPort sendPort = args[0];
      final RootIsolateToken rootIsolateToken = args[1];

      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final FirebaseFirestore firestore = FirebaseService.instance.firestore;

      final QuerySnapshot productsSnapshot = await firestore
          .collection('products')
          .get(); // .where('in_stock', isEqualTo: true).get();

      List<ProductModel> products = productsSnapshot.docs.map((doc) {
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
          rentalPeriod: data['rental_period'] ?? '',
        );
      }).toList();

      sendPort.send(products);
    } catch (e) {
      print("Error loading products: $e");
    }
  }
}
