class LeaseModel {
  final String userId;
  final String type;
  final String name;
  final String description;
  final String price;
  final String rentalPeriod;
  final String condition;
  final List<String> categories;
  final String? imageUrl;

  LeaseModel({
    required this.userId,
    required this.type,
    required this.name,
    required this.description,
    required this.price,
    required this.rentalPeriod,
    required this.condition,
    required this.categories,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'type': type,
      'name': name,
      'description': description,
      'price': price,
      'rental_period': rentalPeriod,
      'condition': condition,
      'categories': categories,
      if (imageUrl != null && imageUrl!.isNotEmpty) 'image_url': imageUrl,
    };
  }
}
