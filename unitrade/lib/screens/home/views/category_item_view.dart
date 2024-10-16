import 'package:flutter/material.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return GestureDetector(
      onTap: () {
        onTap(title);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
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
          SizedBox(height: 8.0),
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
  }
}