import 'package:hive/hive.dart';

part 'product_model.g.dart'; // Required for the generated adapter

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final double price;
  @HiveField(5)
  final double rating;
  @HiveField(6)
  final int reviews;
  @HiveField(7)
  final bool inStock;
  @HiveField(8)
  final List<String> categories;
  @HiveField(9)
  final String condition;
  @HiveField(10)
  final String userId;
  @HiveField(11)
  final String type;
  @HiveField(12)
  final int favoritesForyou;
  @HiveField(13)
  final int favoritesCategory;
  @HiveField(14)
  final int favorites;
  @HiveField(15)
  final String rentalPeriod;
  @HiveField(16)
  final String buyer_id;
  @HiveField(17)
  final String purchase_date;
  @HiveField(18)
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
    this.favoritesForyou = 0,
    this.favoritesCategory = 0,
    this.favorites = 0,
    this.rentalPeriod = '',
    this.buyer_id = '',
    this.purchase_date = '',
  });
}
