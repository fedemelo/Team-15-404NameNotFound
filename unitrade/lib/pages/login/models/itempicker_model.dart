import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemPickerModel {
  // Fetch categories from Firebase
  Future<List<String>> fetchCategories() async {
      print("CATEGORIES~~~~~~~~~~~~~~~~~~~~~");
    final categoriesDoc = await FirebaseFirestore.instance
        .collection('categories')
        .doc('all')
        .get();

      print("CATEGORIES~~~~~~~~~~~~~~~~~~~~~");
      print(categoriesDoc);
    if (categoriesDoc.exists) {
      List<dynamic> categories = categoriesDoc.data()?['names'] ?? [];
      return categories.map((category) => category.toString()).toList();
    } else {
      throw Exception("Categories not found");
    }
  }

  // Update user-selected categories in Firebase
  Future<void> updateUserCategories(List<String> selectedCategories) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      'categories': selectedCategories,
    });
  }
}
