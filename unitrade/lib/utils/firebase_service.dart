import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:unitrade/screens/login/views/welcome_view.dart';

class FirebaseService {
  FirebaseService._privateConstructor();

  // Singleton instance
  static final FirebaseService _instance =
      FirebaseService._privateConstructor();

  // Public accessor for the singleton instance
  static FirebaseService get instance => _instance;

  // Firebase services as instance variables
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Public getters
  FirebaseAuth get auth => _firebaseAuth;
  FirebaseFirestore get firestore => _firebaseFirestore;
  FirebaseStorage get storage => _storage;

  Future<void> getUser(BuildContext context) async {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        // NAVIGATE TO LOGIN SCREEN
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeView()),
        );
      } else {
        print('User is signed in!');
      }
    });
  }
}
