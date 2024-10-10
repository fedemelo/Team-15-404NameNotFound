import 'package:flutter/material.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/screens/upload/views/upload_path_view.dart';
import 'package:unitrade/utils/app_colors.dart';

class NavBarView extends StatefulWidget {
  const NavBarView({super.key});

  @override
  NavBarViewState createState() => NavBarViewState();
}

class NavBarViewState extends State<NavBarView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding view
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
        break;
      case 1:
        // Shopping cart logic
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadPathView()),
        );
        break;
      case 3:
        // Notifications logic
        break;
      case 4:
        // Profile logic
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.primary900,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              color: AppColors.contrast900,
            ),
            onPressed: () => _onItemTapped(0),
          ),
          IconButton(
            icon: Icon(
              _selectedIndex == 1
                  ? Icons.shopping_cart
                  : Icons.shopping_cart_outlined,
              color: AppColors.contrast900,
            ),
            onPressed: () => _onItemTapped(1),
          ),
          IconButton(
            icon: Icon(
              _selectedIndex == 2 ? Icons.add_circle : Icons.add_circle_outline,
              color: AppColors.contrast900,
            ),
            onPressed: () => _onItemTapped(2),
          ),
          IconButton(
            icon: Icon(
              _selectedIndex == 3
                  ? Icons.notifications
                  : Icons.notifications_none_outlined,
              color: AppColors.contrast900,
            ),
            onPressed: () => _onItemTapped(3),
          ),
          IconButton(
            icon: Icon(
              _selectedIndex == 4 ? Icons.person : Icons.person_outline,
              color: AppColors.contrast900,
            ),
            onPressed: () => _onItemTapped(4),
          ),
        ],
      ),
    );
  }
}
