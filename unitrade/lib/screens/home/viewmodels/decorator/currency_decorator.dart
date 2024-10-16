import 'package:unitrade/screens/home/viewmodels/decorator/price_decorator.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/price.dart';

class CurrencyDecorator extends PriceDecorator {
  CurrencyDecorator(Price wrappee) : super(wrappee);

  @override
  String getPrice() {
    return 'COP \$ ${super.getPrice()}';
  }
}
