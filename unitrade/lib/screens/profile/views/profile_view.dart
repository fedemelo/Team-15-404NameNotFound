import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/screens/profile/views/my_orders_view.dart';
import 'package:unitrade/screens/profile/views/theme_view.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:unitrade/utils/firebase_service.dart';
import 'package:unitrade/screens/profile/views/listings_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBarView(initialIndex: 3),
      appBar: AppBar(
        elevation: 1.0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        AssetImage('lib/assets/images/profile_avatar.png'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hello, ',
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user!.displayName ?? 'onboarder',
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).textTheme.headlineLarge!.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // List of options
            Expanded(
              child: ListView(
                children: [
                  // My Listings
                  ListTile(
                    title: Text(
                      "My Listings",
                      style: GoogleFonts.urbanist(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListingsView()),
                      );
                    },
                  ),
                  // My Orders
                  ListTile(
                    title: Text(
                      "My Orders",
                      style: GoogleFonts.urbanist(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyOrdersView()),
                      );
                    },
                  ),
                  // Light/Dark Mode (Navigates to Theme Settings)
                  ListTile(
                    title: Text(
                      "Light/Dark Mode",
                      style: GoogleFonts.urbanist(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ThemeView()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Sign Out button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                width: 170,
                child: ElevatedButton(
                  onPressed: () async {
                    final FirebaseService firebaseService =
                        FirebaseService.instance;
                    firebaseService.auth.signOut();
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    firebaseService.getUser(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.primary900),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 18),
                    ),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.power_settings_new),
                      const SizedBox(width: 12),
                      Text(
                        'SIGN OUT',
                        style: GoogleFonts.urbanist(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
