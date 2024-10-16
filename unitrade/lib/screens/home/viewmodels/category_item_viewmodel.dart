import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unitrade/utils/firebase_service.dart';

class CategoryItemViewModel extends ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  Future<void> updateCategoryClick(String category) async {

    if (category == 'For You') {
      return;
    }

    String uppercasedCategory = category.toUpperCase();

    final DocumentReference categoryDoc = _firestore
        .collection('analytics')
        .doc('click_categories')
        .collection('all')
        .doc(uppercasedCategory);

    try {

      final docSnapshot = await categoryDoc.get();

      if (docSnapshot.exists) {

        await categoryDoc.update({
          'clicks': FieldValue.increment(1),
        });
      } else {

        await categoryDoc.set({
          'clicks': 1,
        });
      }
      notifyListeners();
    } catch (e) {
      print("Error updating click count: $e");
    }
  }
}