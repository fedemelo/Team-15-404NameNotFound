import 'package:flutter/material.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/pages/login/login.dart';
import 'package:unitrade/pages/login/register.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNeutral,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LOGO
              const Image(
                image: AssetImage('lib/assets/images/unitrade_logo.png'),
              ),
              const SizedBox(
                height: 50,
              ),

              // TITLE
              Text(
                'Discover the \n best offers',
                style: GoogleFonts.urbanist(
                    fontSize: 36,
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 30,
              ),

              // DESCRIPTION
              Text(
                'Get all the materials for your classes without \n feeling that you’re paying too much.',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              // BUTTON CONTAINER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // LOGIN BUTTON
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary900,
                        minimumSize: const Size(140, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'LOGIN',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: AppColors.primaryNeutral,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // REGISTER BUTTON
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.primary900,
                        ),
                        backgroundColor: AppColors.primaryNeutral,
                        minimumSize: const Size(140, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'REGISTER',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: AppColors.primary900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
