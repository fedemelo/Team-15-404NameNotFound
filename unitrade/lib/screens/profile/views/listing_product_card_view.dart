import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/utils/app_colors.dart';

class ListingProductCard extends StatelessWidget {
  final ProductModel product;

  const ListingProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(16.0),

      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: product.imageUrl.isNotEmpty
                ? Image.network(
                    product.imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 80,
                    width: 80,
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
          const SizedBox(width: 12.0),
          // Product Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: AppColors.primary900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  product.type == 'sale' ? 'For Sale' : 'For Rent',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: AppColors.secondary900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Saves Section
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product.favorites.toString(),
                style: GoogleFonts.urbanist(
                  fontSize: 30,
                  color: AppColors.primary900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Saves',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: AppColors.primary900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
