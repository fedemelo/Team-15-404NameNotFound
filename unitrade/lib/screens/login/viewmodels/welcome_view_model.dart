import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/screens/login/views/itempicker_view.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:unitrade/utils/connectivity_service.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:unitrade/utils/analytic_service.dart';
import 'package:unitrade/utils/screen_time_service.dart';

class WelcomeViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService.instance;
  
  bool authButtonLoading = false;

  // Microsoft sign-in using OAuthProvider
  Future<void> signInWithMicrosoft(BuildContext context) async {

    final screenTimeService = Provider.of<ScreenTimeService>(context, listen: false);
    
    authButtonLoading = true;
    notifyListeners();

    var connectivity = ConnectivityService();
    var hasConnection = await connectivity.checkConnectivity();
    // If no connection, show a SnackBar and stop the execution
    if (!hasConnection) {
      authButtonLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No internet connection. Please try again when connected.",
            style: TextStyle(color: AppColors.primaryNeutral),
          ),
          duration: Duration(days: 365),
          showCloseIcon: true,
          closeIconColor: AppColors.primaryNeutral,
          backgroundColor: AppColors.danger,


        ),
      );
      return;
    }
    try {
      final userCredential = await microsoftRequest();
      if (userCredential != null && userCredential.user != null) {
        AnalyticService().logSignInStats(userCredential.user!);

        bool isFirstTime = await isFirstTimeUser(userCredential.user!);

        screenTimeService.stopAndRecordTime('LoginView');

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
    } catch (e) {
      print("###Error during Microsoft sign-in: $e");
    } finally {
      authButtonLoading = false;
      notifyListeners();
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
          'name': user.displayName,
          'time_aware_theme': true,
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
