import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/product_model.dart';

class ProductCardViewModel extends ChangeNotifier {

  void toggleFavorite(ProductModel product) {
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }
}
