import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterModel {
  // TODO: Make this a singleton
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  Future<UserCredential> registerUser(String email, String password) async {
    return await _firebase.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> saveUserToFirestore(String uid, String email, String name) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
    }).onError((e, _) => throw Exception("Error writing document: $e"));
  }
}
