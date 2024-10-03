import 'dart:io';

abstract class ProductStrategy {
  Future<void> saveImage(File selectedImage);
  Future<void> saveProductData();
  Map<String, dynamic> toMap();
}
