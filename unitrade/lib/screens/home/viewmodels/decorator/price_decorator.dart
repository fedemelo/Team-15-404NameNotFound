import 'package:unitrade/screens/home/viewmodels/decorator/price.dart';

abstract class PriceDecorator implements Price {
  final Price wrappee;

  PriceDecorator(this.wrappee);

  @override
  String getPrice() {
    return wrappee.getPrice();
  }
}

