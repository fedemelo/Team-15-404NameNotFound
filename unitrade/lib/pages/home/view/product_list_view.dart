import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/models/product_model.dart';
import 'package:unitrade/pages/home/product_card.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;

  ProductListView({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
        );
      },
    );
  }
}
