import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/screens/profile/viewmodels/listings_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
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
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
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
                : viewModel.hasConnection
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: viewModel.products.length,
                          itemBuilder: (context, index) {
                            var product = viewModel.products[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ListingProductCard(product: product),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              size: 80,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Failed to load products. Please check your connection.",
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
