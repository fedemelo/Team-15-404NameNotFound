import 'package:flutter/material.dart';

class ProductCardViewModel extends ChangeNotifier {
  bool isFavorite = false;

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
