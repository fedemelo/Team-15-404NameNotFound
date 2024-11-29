// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[4] as double,
      categories: (fields[8] as List).cast<String>(),
      userId: fields[10] as String,
      type: fields[11] as String,
      imageUrl: fields[3] as String,
      rating: fields[5] as double,
      reviews: fields[6] as int,
      inStock: fields[7] as bool,
      condition: fields[9] as String,
      isFavorite: fields[18] as bool,
      favoritesForyou: fields[12] as int,
      favoritesCategory: fields[13] as int,
      favorites: fields[14] as int,
      rentalPeriod: fields[15] as String,
      buyer_id: fields[16] as String,
      purchase_date: fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.reviews)
      ..writeByte(7)
      ..write(obj.inStock)
      ..writeByte(8)
      ..write(obj.categories)
      ..writeByte(9)
      ..write(obj.condition)
      ..writeByte(10)
      ..write(obj.userId)
      ..writeByte(11)
      ..write(obj.type)
      ..writeByte(12)
      ..write(obj.favoritesForyou)
      ..writeByte(13)
      ..write(obj.favoritesCategory)
      ..writeByte(14)
      ..write(obj.favorites)
      ..writeByte(15)
      ..write(obj.rentalPeriod)
      ..writeByte(16)
      ..write(obj.buyer_id)
      ..writeByte(17)
      ..write(obj.purchase_date)
      ..writeByte(18)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
