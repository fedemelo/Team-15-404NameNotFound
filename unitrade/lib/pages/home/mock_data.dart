import 'package:unitrade/pages/home/models/product_model.dart';

class MockData {
  static const categoryElementList = [
    'For You',
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
    'Category 5',
    'Category 6',
    'Category 7',
  ];

  static const userCategories = [
    'Category 1',
    'Category 2',
  ];

  static final productList = [
    ProductModel(
      id: '1',
      name: 'Product 1',
      description: 'Description 1',
      imageUrl: 'https://picsum.photos/200/300',
      price: 100.0,
      rating: 4.5,
      reviews: 10,
      inStock: true,
      categories: ['Category 1', 'Category 2'],
    ),
    ProductModel(
      id: '2',
      name: 'Product 2',
      description: 'Description 2',
      imageUrl: 'https://picsum.photos/200/300',
      price: 200.0,
      rating: 4.0,
      reviews: 20,
      inStock: false,
      categories: ['Category 1', 'Category 3'],
    ),
    ProductModel(
      id: '3',
      name: 'Product 3',
      description: 'Description 3',
      imageUrl: 'https://picsum.photos/200/300',
      price: 300.0,
      rating: 3.5,
      reviews: 30,
      inStock: true,
      categories: ['Category 2', 'Category 4'],
    ),
    ProductModel(
      id: '4',
      name: 'Product 4',
      description: 'Description 4',
      imageUrl: 'https://picsum.photos/200/300',
      price: 400.0,
      rating: 3.0,
      reviews: 40,
      inStock: false,
      categories: ['Category 3', 'Category 5'],
    ),
    ProductModel(
      id: '5',
      name: 'Product 5',
      description: 'Description 5',
      imageUrl: 'https://picsum.photos/200/300',
      price: 500.0,
      rating: 2.5,
      reviews: 50,
      inStock: true,
      categories: ['Category 4', 'Category 6'],
    ),
    ProductModel(
      id: '6',
      name: 'Product 6',
      description: 'Description 6',
      imageUrl: 'https://picsum.photos/200/300',
      price: 600.0,
      rating: 2.0,
      reviews: 60,
      inStock: false,
      categories: ['Category 5', 'Category 7'],
    ),
    ProductModel(
      id: '7',
      name: 'Product 7',
      description: 'Description 7',
      imageUrl: 'https://picsum.photos/200/300',
      price: 700.0,
      rating: 1.5,
      reviews: 70,
      inStock: true,
      categories: ['Category 6', 'Category 7'],
    ),
    ProductModel(
      id: '8',
      name: 'Product 8',
      description: 'Description 8',
      imageUrl: 'https://picsum.photos/200/300',
      price: 800.0,
      rating: 1.0,
      reviews: 80,
      inStock: false,
      categories: ['Category 7', 'Category 2'],
    ),

  ];


}