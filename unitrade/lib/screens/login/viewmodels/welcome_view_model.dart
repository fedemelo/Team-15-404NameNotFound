import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:unitrade/utils/analytic_service.dart';

class WelcomeViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService.instance;

  // Microsoft sign-in using OAuthProvider
  Future<void> signInWithMicrosoft(BuildContext context) async {
    final userCredential = await microsoftRequest();
    if (userCredential != null && userCredential.user != null) {
      print("User signed in: ${userCredential.user?.displayName}");

      AnalyticService().logSignInStats(userCredential.user!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    } else {
      print("Failed to sign in with Microsoft.");
    }
  }

  Future<UserCredential?> microsoftRequest() async {
    final microsoftProvider = MicrosoftAuthProvider();
    // OAuthProvider microsoftProvider = OAuthProvider('microsoft.com');

    try {
      UserCredential userCredential =
          await _firebaseService.auth.signInWithProvider(microsoftProvider);

      return userCredential;
    } catch (e) {
      print("###Error during Microsoft sign-in: $e");
      return null;
    }
  }
}
