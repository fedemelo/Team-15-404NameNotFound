import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MockHome extends StatelessWidget {
  const MockHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Home'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: const Center(
        child: Text('Mock Home'),
      ),
    );
  }
}
