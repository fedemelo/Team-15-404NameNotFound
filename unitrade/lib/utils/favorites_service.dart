import 'dart:async';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unitrade/utils/firebase_options.dart';

class FavoritesService {
  FavoritesService._privateConstructor();

  static final FavoritesService instance =
      FavoritesService._privateConstructor();

  List<ProductModel>? _favoriteProducts;

  List<ProductModel>? get favoriteProducts => _favoriteProducts;

  Future<void> loadFavoritesInBackground(String userId) async {
    try {
      final Completer<List<ProductModel>> _completer =
          Completer<List<ProductModel>>();
      if (_completer.isCompleted) return;

      if (userId.isEmpty) {
        return;
      }

      if (_favoriteProducts == null) {
        final receivePort = ReceivePort();
        final rootIsolateToken = RootIsolateToken.instance;

        if (rootIsolateToken != null) {
          await Isolate.spawn(_fetchFavoritesInIsolate,
              [receivePort.sendPort, rootIsolateToken, userId]);
        } else {
          return;
        }

        final completer = Completer<List<ProductModel>>();
        receivePort.listen((data) {
          completer.complete(data as List<ProductModel>);
        });

        _favoriteProducts = await completer.future;
      }
    } catch (e) {
      print("Error loading favorite products: $e");
    }
  }

  static Future<void> _fetchFavoritesInIsolate(List<dynamic> args) async {
    try {
    final SendPort sendPort = args[0];
    final RootIsolateToken rootIsolateToken = args[1];
    final String userId = args[2];

    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    List<ProductModel> favoriteProducts = [];


      final FirebaseFirestore firestore = FirebaseService.instance.firestore;

      final DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();

      List<String> favoriteProductIds = [];
      if (userDoc.exists) {
        favoriteProductIds = List<String>.from(
            (userDoc.data() as Map<String, dynamic>)['favorites'] ?? []);
      }

      final QuerySnapshot productsSnapshot =
          await firestore.collection('products').get();

      favoriteProducts = productsSnapshot.docs
          .map((doc) {
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
              favoritesForyou: data['favorites_foryou'] ?? 0,
              favoritesCategory: data['favorites_category'] ?? 0,
              favorites: data['favorites'] ?? 0,
              condition: data['condition'] ?? '',
            );
          })
          .where((product) => favoriteProductIds.contains(product.id))
          .toList();

      sendPort.send(favoriteProducts);
    } catch (e) {
      print("Error fetching favorite products: $e");
    }
  }
}
