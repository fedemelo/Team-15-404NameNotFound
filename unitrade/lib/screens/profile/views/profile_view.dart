import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitrade/utils/firebase_service.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          // Expanded widget to center the content in the middle
          const Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Centers the column's content
                children: [
                  Text(
                    'TODO: Implement Profile View',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Logout button at the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () {
                final FirebaseService firebaseService =
                    FirebaseService.instance;
                firebaseService.auth.signOut();
                firebaseService.getUser(context);
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
