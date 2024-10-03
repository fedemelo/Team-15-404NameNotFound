import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unitrade/utils/firebase_service.dart';

class RegisterModel {
  
  final FirebaseAuth _firebase = FirebaseService.instance.auth;

  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  Future<UserCredential> registerUser(String email, String password) async {
    return await _firebase.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> saveUserToFirestore(String uid, String email, String name) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
    }).onError((e, _) => throw Exception("Error writing document: $e"));
  }
}
