import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:unitrade/utils/firebase_queue_service.dart';
import 'package:unitrade/utils/firebase_queued_request.dart';

class ItemPickerModel {
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;
  final FirebaseQueueService queueService = FirebaseQueueService();

  // Fetch categories from Firebase
  Future<List<String>> fetchCategories() async {
    final categoriesDoc =
        await _firestore.collection('categories').doc('all').get();

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

    await _firestore.collection('users').doc(user.uid).update({
      'categories': selectedCategories,
    });
  }

  void queueUserCategories(List<String> selectedCategories) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');
    queueService.addRequestToQueue(FirebaseQueuedRequest(
      collectionPath: 'users',
      documentId: user.uid,
      data: {'categories': selectedCategories},
      operation: 'update',
    ));
  }
}
