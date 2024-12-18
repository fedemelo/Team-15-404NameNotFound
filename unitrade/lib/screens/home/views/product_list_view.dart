import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/home/views/product_card_view.dart';
import 'package:unitrade/screens/home/views/product_detail_view.dart';
import 'package:unitrade/screens/home/viewmodels/home_viewmodel.dart';
import 'package:unitrade/screens/favorite/viewmodels/favorite_viewmodel.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;
  final bool currentConnection;
  final String selectedCategory;
  final List<String> userFavoriteProducts;
  final Function updateScreen;
  final String lastScreen;

  const ProductListView(
      {super.key,
      required this.products,
      required this.currentConnection,
      required this.selectedCategory,
      required this.userFavoriteProducts,
      required this.updateScreen,
      required this.lastScreen});


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailView(
                    userFavoriteProducts: userFavoriteProducts,
                    product: product,
                    currentConnection: currentConnection,
                    selectedCategory: selectedCategory,
                    lastScreen: lastScreen,
                ),

              ),
            );

            updateScreen();

          },
          child: ProductCardView(
            product: product,
            currentConnection: currentConnection,
            selectedCategory: selectedCategory,
            userFavoriteProducts: userFavoriteProducts,
            lastScreen: lastScreen,
          ),
        );
      },
    );
  }
}
