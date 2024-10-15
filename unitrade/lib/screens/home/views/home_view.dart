import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/views/category_list_view.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/screens/home/views/custom_search_bar_view.dart';
import 'package:unitrade/screens/home/views/product_list_view.dart';
import 'package:unitrade/screens/home/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: viewModel.finishedGets
                    ? Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: ListView(
                          children: [
                            const SizedBox(height: 20),
                            CustomSearchBarView(
                              onChange: viewModel.updateSearch,
                              onClickFilter: () => viewModel.showFilterWidget(
                                  context, viewModel),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Categories',
                              style: GoogleFonts.urbanist(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CategoryListView(
                              categories: viewModel.categoryElementList,
                              selectedCategory: viewModel.selectedCategory,
                              onClick: viewModel.clickCategory,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              viewModel.selectedCategory.isEmpty
                                  ? 'Search'
                                  : viewModel.selectedCategory,
                              style: GoogleFonts.urbanist(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ProductListView(
                              products: viewModel.filteredProducts,
                            ),
                          ],
                        ),
                      )
                    : const CircularProgressIndicator(
                        color: AppColors.primary900,
                      ),
              ),
            ),
            bottomNavigationBar: const NavBarView(),
          );
        },
      ),
    );
  }
}
