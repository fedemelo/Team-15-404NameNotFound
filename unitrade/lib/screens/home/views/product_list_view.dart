import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/home/views/product_card_view.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;
  final bool currentConnection;
  final String selectedCategory;

  ProductListView({required this.products, required this.currentConnection, required this.selectedCategory});

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
        return ProductCardView(
          product: product,
          currentConnection: currentConnection,
          selectedCategory: selectedCategory,
        );
      },
    );
  }
}
