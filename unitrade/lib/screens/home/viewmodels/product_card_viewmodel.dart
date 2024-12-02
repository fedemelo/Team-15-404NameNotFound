import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/price.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/base_price.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/format_decorator.dart';
import 'package:unitrade/screens/home/viewmodels/decorator/currency_decorator.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductCardViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;
  final FirebaseAuth _firebase = FirebaseService.instance.auth;
  final _user = FirebaseService.instance.auth.currentUser;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void toggleFavorite(ProductModel product, String selectedCategory,
      bool currentConnection, List<String> userFavoriteProducts) async {
    if (!currentConnection) {
      return;
    }

    final userDocRef =
        _firestore.collection('users').doc(_firebase.currentUser?.uid);

    if (userFavoriteProducts.contains(product.id)) {
      // Eliminar de favoritos en la lista local y en Firebase
      userFavoriteProducts.remove(product.id);
      await userDocRef.update({
        'favorites': FieldValue.arrayRemove([product.id])
      });
    } else {
      // Agregar a favoritos en la lista local y en Firebase
      userFavoriteProducts.add(product.id);
      await userDocRef.update({
        'favorites': FieldValue.arrayUnion([product.id])
      });
    }

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
  Future<void> buyProduct(ProductModel product, BuildContext context, String lastScreen) async {
    // Get user
    String semester = '';
    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .get()
        .then((userDoc) async {
      if (userDoc.exists) {
        semester = userDoc.data()?['semester'] ?? '';
      }
    });

    await _firestore.collection('products').doc(product.id).update({
      'in_stock': false,
      'buyer_id': _user!.uid,
      'purchase_date': DateTime.now().toLocal().toString().split(' ')[0],
      'buyer_semester': semester,
    });

    final boughtFromDoc = _firestore.collection('analytics').doc('bought_from');
    final DocumentSnapshot docSnapshot = await boughtFromDoc.get();


    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      if (lastScreen == 'favorites') {
        int currentFavoritesCount = data['favorites'] ?? 0;
        await boughtFromDoc.update({
          'favorites': currentFavoritesCount + 1,
        });
      } else if (lastScreen == 'home') {
        int currentHomeCount = data['home'] ?? 0;
        await boughtFromDoc.update({
          'home': currentHomeCount + 1,
        });
      }
    }

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
