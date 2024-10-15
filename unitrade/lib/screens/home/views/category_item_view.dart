import 'package:flutter/material.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/viewmodels/category_item_viewmodel.dart';

class CategoryItemView extends StatelessWidget {
  final IconData icon;
  final String title;
  final int itemCount;
  final bool selected;
  final void Function(String) onTap;

  CategoryItemView({
    required this.icon,
    required this.title,
    required this.itemCount,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryItemViewModel(),
      child: Consumer<CategoryItemViewModel>(
        builder: (context, viewModel, child) {
          return GestureDetector(
            onTap: () {
              onTap(title);
              viewModel.updateCategoryClick(title);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.secondary900 : AppColors.primary900,
                  ),
                  child: Icon(
                    icon,
                    size: 32.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}