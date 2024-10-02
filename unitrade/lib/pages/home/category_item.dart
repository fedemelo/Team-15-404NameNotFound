import 'package:flutter/material.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final int itemCount;
  final bool selected;
  final void Function(String) onTap;

  CategoryItem({
    required this.icon,
    required this.title,
    required this.itemCount,
    required this.selected,
    required this.onTap,
  });

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.title);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.selected ? Colors.orange : AppColors.primary900,
            ),
            child: Icon(
              widget.icon,
              size: 32.0,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            widget.title,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: AppColors.primary900,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            '${widget.itemCount} Items',
            style: GoogleFonts.urbanist(
              fontSize: 11,
              color: AppColors.primary900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
