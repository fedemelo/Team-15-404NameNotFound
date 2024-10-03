import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:unitrade/pages/home/models/product_model.dart';
import 'package:unitrade/pages/home/viewmodels/product_card_viewmodel.dart';

class ProductCardView extends StatelessWidget {
  final ProductModel product;

  ProductCardView({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductCardViewModel(),
      child: Consumer<ProductCardViewModel>(
        builder: (context, productViewModel, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          product.imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            productViewModel.toggleFavorite();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              productViewModel.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: productViewModel.isFavorite
                                  ? Colors.red
                                  : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    product.name,
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4.0),
                      Text(
                        product.rating.toString(),
                        style: GoogleFonts.urbanist(
                          color: AppColors.primaryDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '(${product.reviews} Reviews)',
                        style: GoogleFonts.urbanist(
                          color: AppColors.light400,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '\$${product.price}',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    product.inStock ? 'In stock' : 'Out of stock',
                    style: const TextStyle(
                      color: AppColors.primary900,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
