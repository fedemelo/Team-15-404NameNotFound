import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Fetch majors from Firebase
  Future<List<String>> fetchMajors() async {
    final majorsDoc =
        await _firestore.collection('categories').doc('majors').get();

    if (majorsDoc.exists) {
      List<dynamic> majors = majorsDoc.data()?['names'] ?? [];
      return majors.map((major) => major.toString()).toList();
    } else {
      throw Exception("Majors not found");
    }
  }

  // Update user-selected categories in Firebase
  Future<void> updateUserInformation(List<String> selectedCategories,
      String selectedMajor, String selectedSemester) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    localSaveUserInformation(
        selectedCategories, selectedMajor, selectedSemester);
    await _firestore.collection('users').doc(user.uid).update({
      'categories': selectedCategories,
      'major': selectedMajor,
      'semester': selectedSemester,
    });
  }

  void queueUserInformation(List<String> selectedCategories,
      String selectedMajor, String selectedSemester) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');
    queueService.addRequestToQueue(FirebaseQueuedRequest(
      collectionPath: 'users',
      documentId: user.uid,
      data: {
        'categories': selectedCategories,
        'major': selectedMajor,
        'semester': selectedSemester
      },
      operation: 'update',
    ));
  }

  // This method is used to save the user-selected categories locally
  Future<void> localSaveUserInformation(
    List<String> selectedCategories,
    String selectedMajor,
    String selectedSemester,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('categories', selectedCategories);
    await prefs.setString('major', selectedMajor);
    await prefs.setString('semester', selectedSemester);
  }
}
