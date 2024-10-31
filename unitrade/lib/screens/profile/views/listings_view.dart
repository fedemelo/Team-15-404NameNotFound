import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/screens/profile//viewmodels/listings_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/profile/views/listing_product_card_view.dart';

class ListingsView extends StatelessWidget {
  const ListingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListingsViewModel(),
      child: Consumer<ListingsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            bottomNavigationBar: const NavBarView(initialIndex: 4),
            appBar: AppBar(
              elevation: 1.0,
              title: Text(
                'Product Listings',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: viewModel.isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary900,
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: viewModel.products.length,
                itemBuilder: (context, index) {
                  ProductModel product = viewModel.products[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ListingProductCard(product: product),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
