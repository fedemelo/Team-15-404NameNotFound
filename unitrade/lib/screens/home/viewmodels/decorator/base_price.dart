import 'package:unitrade/screens/home/viewmodels/decorator/price.dart';

class BasePrice implements Price {
  final String price;

  BasePrice(this.price);

  @override
  String getPrice() {
    return price;
  }
}
