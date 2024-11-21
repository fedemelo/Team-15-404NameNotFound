import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/home/viewmodels/product_card_viewmodel.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/utils/app_colors.dart';

class ProductDetailView extends StatelessWidget {
  final ProductModel product;
  final bool currentConnection;
  final String selectedCategory;

  const ProductDetailView(
      {super.key,
      required this.product,
      required this.currentConnection,
      required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductCardViewModel(),
      child: Consumer<ProductCardViewModel>(
        builder: (context, productViewModel, child) {
          return Scaffold(
            bottomNavigationBar: const NavBarView(initialIndex: 0),
            appBar: AppBar(
              elevation: 1.0,
              title: Text(
                '',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child:
                                product.imageUrl.isNotEmpty && currentConnection
                                    ? Image.network(
                                        product.imageUrl,
                                        height: 300,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 300,
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
                                productViewModel.toggleFavorite(product,
                                    selectedCategory, currentConnection);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
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
                                  product.isFavorite
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
                      const SizedBox(height: 16),
                      Text(
                        product.name,
                        style: GoogleFonts.urbanist(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Description',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.description,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PRICE',
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                productViewModel.processPrice(product.price),
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 64),
                          ElevatedButton(
                            onPressed: () {
                              // TODO
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  AppColors.primary900),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    horizontal: 22, vertical: 16),
                              ),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shopping_cart_outlined),
                                const SizedBox(width: 12),
                                Text(
                                  product.type == 'sale'
                                      ? 'BUY NOW'
                                      : 'RENT NOW',
                                  style: GoogleFonts.urbanist(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
