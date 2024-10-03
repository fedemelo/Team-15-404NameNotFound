import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/view/category_list_view.dart';
import 'package:unitrade/pages/home/view/nav_bar_view.dart';
import 'package:unitrade/pages/home/view/custom_search_bar_view.dart';
import 'package:unitrade/pages/home/view/product_list_view.dart';
import 'package:unitrade/pages/home/view/filter_section_view.dart';
import 'package:unitrade/pages/home/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showFilterWidget(BuildContext context, HomeViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterSectionView(
          actualFilters: viewModel.filters,
          onUpdateFilters: viewModel.updateFilters,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      CustomSearchBarView(
                        onChange: viewModel.updateSearch,
                        onClickFilter: () => _showFilterWidget(context, viewModel),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Categories',
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          color: AppColors.primary900,
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
                        viewModel.selectedCategory,
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          color: AppColors.primary900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ProductListView(
                        products: viewModel.filteredProducts,
                      ),
                    ],
                  ),
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
