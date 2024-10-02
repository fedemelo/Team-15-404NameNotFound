import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  
  FirebaseService._privateConstructor();

  // Singleton instance
  static final FirebaseService _instance = FirebaseService._privateConstructor();

  // Public accessor for the singleton instance
  static FirebaseService get instance => _instance;

  // Firebase services as instance variables
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Public getters for accessing FirebaseAuth and Firestore
  FirebaseAuth get auth => _firebaseAuth;
  FirebaseFirestore get firestore => _firebaseFirestore;
}
