import 'dart:io';

abstract class UploadProductStrategy {
  Future<void> saveImage(File selectedImage);
  Future<void> saveProductData();
  Map<String, dynamic> toMap();
}
