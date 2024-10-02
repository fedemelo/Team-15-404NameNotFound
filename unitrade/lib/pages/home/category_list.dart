import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/category_item.dart';

class CategoryList extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onClick;

  CategoryList({
    required this.categories,
    required this.selectedCategory,
    required this.onClick,
  });

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.categories.map(
          (category) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CategoryItem(
                icon: Icons.category,
                title: category,
                itemCount: 5,
                selected: widget.selectedCategory == category,
                onTap: widget.onClick,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
