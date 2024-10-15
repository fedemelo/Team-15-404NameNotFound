import 'package:flutter/material.dart';

import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchBarView extends StatelessWidget {
  final void Function(String) onChange;

  final void Function() onClickFilter;

  const CustomSearchBarView({
    required this.onChange,
    required this.onClickFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primary900, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              print('search icon pressed ');
            },
            child: Icon(Icons.search, color: AppColors.primary900),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'What are you looking for?',
                hintStyle: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: AppColors.light400,
                    fontWeight: FontWeight.w600),
                border: InputBorder.none,
              ),
              onSubmitted: onChange,
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: onClickFilter,
            child: Icon(Icons.tune, color: AppColors.primary900),
          ),
        ],
      ),
    );
  }
}
