import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unitrade/pages/upload/upload.dart';
import 'package:unitrade/utils/app_colors.dart';

final _firebase = Firebase.initializeApp();

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.primary900,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Color.fromARGB(255, 112, 70, 27)),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined,
                color: AppColors.contrast900),
            onPressed: () {
              // Shopping cart logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: AppColors.contrast900),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Upload()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined,
                color: AppColors.contrast900),
            onPressed: () {
              // Notifications logic
            },
          ),
          IconButton(
            icon:
                const Icon(Icons.person_outline, color: AppColors.contrast900),
            onPressed: () {
              // Profile logic
            },
          ),
        ],
      ),
    );
  }
}
