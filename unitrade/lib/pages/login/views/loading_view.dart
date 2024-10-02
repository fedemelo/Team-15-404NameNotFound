import 'package:flutter/material.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/pages/login/views/welcome_page.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  // Here we define a timeout before redirecting to the login page
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );

      // Listen to the auth state
      // TODO: Uncomment this code when the auth state is implemented
      // FirebaseAuth.instance.authStateChanges().listen((User? user) {
      //   if (user != null) {
      //     // User is logged in, redirect to Home page
      //     print("USER LOGGED IN~~~~~~~~~~~~~~~~~~~~~~");
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const Home()),
      //     );
      //   } else {
      //     // User is not logged in, redirect to Welcome page
      //     print("USER NOT LOGGED IN~~~~~~~~~~~~~~~~~~~~~~");
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const WelcomePage()),
      //     );
      //   }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary900,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image:
                    AssetImage('lib/assets/images/unitrade_logo_loadapp.png'),
              ),
              Text(
                'UniTrade',
                style: GoogleFonts.urbanist(
                    fontSize: 36,
                    color: AppColors.primaryNeutral,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
