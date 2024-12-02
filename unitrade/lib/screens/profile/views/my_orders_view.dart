import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/screens/profile/viewmodels/my_orders_viewmodel.dart';
import 'package:unitrade/screens/profile/views/my_orders_product_card_view.dart';
import 'package:unitrade/utils/app_colors.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyOrdersViewmodel(),
      child: Consumer<MyOrdersViewmodel>(builder: (context, viewModel, child) {
        return Scaffold(
          bottomNavigationBar: const NavBarView(initialIndex: 3),
          appBar: AppBar(
            elevation: 1.0,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
            ),
            title: Text(
              'My Orders',
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
              : viewModel.products.isNotEmpty
                  ? Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            itemCount: viewModel.products.length,
                            itemBuilder: (context, index) {
                              var product = viewModel.products[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: MyOrdersProductCard(product: product),
                              );
                            },
                          ),
                        ),
                        if (viewModel.isOfflineData)
                          Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Theme.of(context).colorScheme.surface,
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                "You're viewing offline data. It may be outdated.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
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
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load products. \n Please check your connection.',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      }),
    );
  }
}
