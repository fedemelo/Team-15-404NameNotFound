import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/price.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/base_price.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/format_decorator.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/currency_decorator.dart';
import 'package:unitrade/utils/firebase_service.dart';

class ProductCardViewModel extends ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  void toggleFavorite(ProductModel product, String selectedCategory, bool currentConnection) async {
    if (!currentConnection) {
      return;
    }

    product.isFavorite = !product.isFavorite;

    final DocumentReference productDoc = _firestore.collection('products').doc(product.id);

    if (selectedCategory == 'For You') {
      await productDoc.get().then((doc) async {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          int currentFavoritesForYou = data['favorites_foryou'] ?? 0;
          int newFavoritesForYou = product.isFavorite
              ? currentFavoritesForYou + 1
              : (currentFavoritesForYou > 0 ? currentFavoritesForYou - 1 : 0);

          await productDoc.update({'favorites_foryou': newFavoritesForYou});
        } else {
          await productDoc.set({
            'favorites_foryou': product.isFavorite ? 1 : 0,
          }, SetOptions(merge: true));
        }
      });
    } else {
      await productDoc.get().then((doc) async {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          int currentFavoriteCategory = data['favorite_category'] ?? 0;
          int newFavoriteCategory = product.isFavorite
              ? currentFavoriteCategory + 1
              : (currentFavoriteCategory > 0 ? currentFavoriteCategory - 1 : 0);

          await productDoc.update({'favorite_category': newFavoriteCategory});
        } else {
          await productDoc.set({
            'favorite_category': product.isFavorite ? 1 : 0,
          }, SetOptions(merge: true));
        }
      });
    }

    notifyListeners();
  }

  String processPrice(double price) {
    String priceString = price.toStringAsFixed(2);

    Price basePrice = BasePrice(priceString);

    Price formattedPrice = FormatDecorator(basePrice);
    Price finalPrice = CurrencyDecorator(formattedPrice);

    return finalPrice.getPrice();
  }
}
