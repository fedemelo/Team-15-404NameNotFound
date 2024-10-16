import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/views/category_item_view.dart';
import 'package:unitrade/screens/home/category_data.dart';

class CategoryListView extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onClick;

  CategoryListView({
    required this.categories,
    required this.selectedCategory,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map(
          (category) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CategoryItemView(
                icon: categoryIcons[category] ?? Icons.category,
                title: category,
                itemCount: 5,
                selected: selectedCategory == category,
                onTap: onClick,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
