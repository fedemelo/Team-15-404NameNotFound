import 'package:unitrade/screens/home/viewmodels/decorator/price_decorator.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/price.dart';

class FormatDecorator extends PriceDecorator {
  FormatDecorator(Price wrappee) : super(wrappee);

  @override
  String getPrice() {
    String formattedPrice = super.getPrice();
    return formattedPrice.replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }
}
