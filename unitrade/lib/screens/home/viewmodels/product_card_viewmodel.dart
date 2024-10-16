import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/price.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/base_price.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/format_decorator.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/currency_decorator.dart';

class ProductCardViewModel extends ChangeNotifier {

  void toggleFavorite(ProductModel product) {
    product.isFavorite = !product.isFavorite;
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
