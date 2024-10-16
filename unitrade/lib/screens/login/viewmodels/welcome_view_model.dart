import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/screens/login/views/itempicker_view.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:unitrade/utils/analytic_service.dart';

class WelcomeViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService.instance;

  // Microsoft sign-in using OAuthProvider
  Future<void> signInWithMicrosoft(BuildContext context) async {
    final userCredential = await microsoftRequest();
    if (userCredential != null && userCredential.user != null) {
      AnalyticService().logSignInStats(userCredential.user!);

      bool isFirstTime = await isFirstTimeUser(userCredential.user!);

      if (isFirstTime) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ItempickerView()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      }
    } else {
      print("Failed to sign in with Microsoft.");
    }
  }

  Future<UserCredential?> microsoftRequest() async {
    final microsoftProvider = MicrosoftAuthProvider();

    try {
      UserCredential userCredential =
          await _firebaseService.auth.signInWithProvider(microsoftProvider);

      return userCredential;
    } catch (e) {
      print("###Error during Microsoft sign-in: $e");
      return null;
    }
  }

  Future<bool> isFirstTimeUser(User user) async {
    try {
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userDoc.exists) {
        // If the user record doesn't exist, create one
        await _firebaseService.firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName,
          'createdAt': DateTime.now(),
        });
        return true;
      }
      return false;
    } catch (e) {
      print("### Error checking user registration status: $e");
      return false;
    }
  }

  Future<void> saveUserToFirestore(
      String uid, String email, String name) async {
    await _firebaseService.firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
    }).onError((e, _) => throw Exception("Error writing document: $e"));
  }
}
