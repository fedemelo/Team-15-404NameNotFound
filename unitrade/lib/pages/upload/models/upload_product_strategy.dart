import 'dart:io';

abstract class UploadProductStrategy {
  Future<void> saveImage(File selectedImage);
  Future<void> saveProduct();
  Map<String, dynamic> toMap();
}
