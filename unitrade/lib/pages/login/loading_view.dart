import 'package:flutter/material.dart';
import 'package:unitrade/app_colors.dart';
import 'package:unitrade/pages/login/login_page.dart';
import 'package:google_fonts/google_fonts.dart';

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
        MaterialPageRoute(
            builder: (context) =>
                const LoginPage()),
      );
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
                image: AssetImage('lib/assets/images/unitrade_logo_loadapp.png'),
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
