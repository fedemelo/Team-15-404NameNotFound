import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/screens/home/views/product_list_view.dart';
import 'package:unitrade/screens/favorite/viewmodels/favorite_viewmodel.dart';
import 'package:unitrade/utils/app_colors.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteViewModel(),
      child: Consumer<FavoriteViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            bottomNavigationBar: const NavBarView(initialIndex: 2),
            appBar: AppBar(
              elevation: 1.0,
              automaticallyImplyLeading: false,
              title: Text(
                'My Favorites',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: viewModel.finishedGets
                ? (viewModel.currentConnection
                    ? (viewModel.productElementList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ProductListView(
                              products: viewModel.productElementList,
                              currentConnection: viewModel.currentConnection,
                              selectedCategory: "Favorites",
                              userFavoriteProducts: viewModel.favoriteProducts,
                              updateScreen: viewModel.updateScreen,
                              lastScreen: 'favorites',
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 80,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No favorite products yet.',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ))
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
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ))
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary900,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
