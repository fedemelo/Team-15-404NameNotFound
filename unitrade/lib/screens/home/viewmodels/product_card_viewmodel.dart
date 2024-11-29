import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/price.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/base_price.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/format_decorator.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/currency_decorator.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/utils/firebase_service.dart';

class ProductCardViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;
  final _user = FirebaseService.instance.auth.currentUser;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void toggleFavorite(ProductModel product, String selectedCategory,
      bool currentConnection) async {
    if (!currentConnection) {
      return;
    }

    // Alternar el estado de favorito
    product.isFavorite = !product.isFavorite;

    final DocumentReference productDoc =
        _firestore.collection('products').doc(product.id);

    await productDoc.get().then((doc) async {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Manejo de favorites_foryou
        if (selectedCategory == 'For You') {
          int currentFavoritesForYou = data['favorites_foryou'] ?? 0;
          if (product.isFavorite) {
            await productDoc
                .update({'favorites_foryou': currentFavoritesForYou + 1});
          }
        } else {
          int currentFavoriteCategory = data['favorites_category'] ?? 0;
          if (product.isFavorite) {
            await productDoc
                .update({'favorites_category': currentFavoriteCategory + 1});
          }
        }

        // Manejo de favorites (total de favoritos)
        int currentFavorites = data['favorites'] ?? 0;
        int newFavorites = product.isFavorite
            ? currentFavorites + 1
            : (currentFavorites > 0 ? currentFavorites - 1 : 0);
        await productDoc.update({'favorites': newFavorites});
      } else {
        // Crear las variables en Firestore si no existen
        Map<String, dynamic> newData = {};
        if (product.isFavorite) {
          if (selectedCategory == 'For You') {
            newData['favorites_foryou'] = 1;
          } else {
            newData['favorites_category'] = 1;
          }
          newData['favorites'] = 1;
        } else {
          // Si se quita de favoritos y no existen las variables, se inician en 0
          newData['favorites_foryou'] = 0;
          newData['favorites_category'] = 0;
          newData['favorites'] = 0;
        }
        await productDoc.set(newData, SetOptions(merge: true));
      }
    });

    notifyListeners();
  }

  String processPrice(double price) {
    String priceString = price.toStringAsFixed(0);

    Price basePrice = BasePrice(priceString);

    Price formattedPrice = FormatDecorator(basePrice);
    Price finalPrice = CurrencyDecorator(formattedPrice);

    return finalPrice.getPrice();
  }

  // For product detail
  Future<void> buyProduct(ProductModel product, BuildContext context) async {
    await _firestore.collection('products').doc(product.id).update({
      'in_stock': false,
      'buyer_id': _user!.uid,
      'purchase_date': DateTime.now().toLocal().toString().split(' ')[0],
    });

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text('Product purchased successfully!'),
            ),
            IconButton(
              icon: Icon(Icons.close,
                  color: Theme.of(context).colorScheme.surface),
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              },
            ),
          ],
        ),
        duration: const Duration(minutes: 1),
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomeView(),
      ),
    );
  }
}
