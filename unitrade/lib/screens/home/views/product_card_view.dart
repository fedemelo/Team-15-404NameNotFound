import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/home/viewmodels/product_card_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:unitrade/screens/favorite/viewmodels/favorite_viewmodel.dart';

class ProductCardView extends StatelessWidget {
  final ProductModel product;
  final bool currentConnection;
  final String selectedCategory;
  final List<String> userFavoriteProducts;
  final String lastScreen;

  ProductCardView({
    required this.product,
    required this.currentConnection,
    required this.selectedCategory,
    required this.userFavoriteProducts,
    required this.lastScreen,
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
                        child: product.imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: product.imageUrl,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                              )
                            : Container(
                                height: 150,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            productViewModel.toggleFavorite(
                                product,
                                selectedCategory,
                                currentConnection,
                                userFavoriteProducts,
                                  () {
                                Provider.of<FavoriteViewModel>(context, listen: false).updateFavoritesList();
                              },
                              lastScreen,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                              userFavoriteProducts.contains(product.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.primary900,
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
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4.0),
                      Text(
                        product.rating == 0 ? "-" : product.rating.toString(),
                        style: GoogleFonts.urbanist(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
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
                    productViewModel.processPrice(product.price),
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    product.type == "sale" ? 'For Sale' : 'For Rent',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineLarge?.color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
