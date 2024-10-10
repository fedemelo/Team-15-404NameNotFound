import 'dart:io';

abstract class UploadProductStrategy {
  Future<void> saveImage(File selectedImage, String imgSource);
  Future<void> saveProduct();
  Map<String, dynamic> toMap();
}
