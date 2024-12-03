import 'package:flutter/material.dart';
import 'package:unitrade/screens/favorite/views/favorite_view.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/screens/profile/views/profile_view.dart';
import 'package:unitrade/screens/upload/views/upload_path_view.dart';
import 'package:unitrade/utils/app_colors.dart';

class NavBarView extends StatefulWidget {
  final int initialIndex;

  const NavBarView({super.key, this.initialIndex = 0});

  @override
  NavBarViewState createState() => NavBarViewState();
}

class NavBarViewState extends State<NavBarView> {
  late int _selectedIndex;


  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    // Only update the state if the index is different to prevent re-navigation
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      // Navigate to the corresponding view
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadPathView()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoriteView()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileView()),
          );
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.primary900,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, Icons.home_outlined, "Home", 0),
          _buildNavItem(
              Icons.add_circle, Icons.add_circle_outline, "Upload", 1),
          _buildNavItem(
              Icons.favorite, Icons.favorite_border_outlined, "Favorites", 2),
          _buildNavItem(Icons.person, Icons.person_outline, "Profile", 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData selectedIcon, IconData unselectedIcon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : unselectedIcon,
                color: AppColors.contrast900,
              ),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.contrast900,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
