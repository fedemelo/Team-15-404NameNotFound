import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {

  // TODO: Make this a singleton
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  Future<void> login() async {
    if (_email.isEmpty || _password.isEmpty) {
      _errorMessage = "Please fill in all fields";
      notifyListeners();
      return;
    }

    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);

    if (!regex.hasMatch(_email)) {
      _errorMessage = "Please enter a valid email address";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _firebase.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      _errorMessage = null; // Reset any error message
    } on FirebaseAuthException catch (error) {
      _errorMessage = error.message ?? "Login failed";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
