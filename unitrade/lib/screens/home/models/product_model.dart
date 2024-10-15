class ProductModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final int reviews;
  final bool inStock;
  final List<String> categories;
  final String condition;
  final String userId;
  final String type;

  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categories,
    required this.userId,
    required this.type,
    this.imageUrl = '',
    this.rating = 0.0,
    this.reviews = 0,
    this.inStock = true,
    this.condition = 'new',
    this.isFavorite = false,
  });
}