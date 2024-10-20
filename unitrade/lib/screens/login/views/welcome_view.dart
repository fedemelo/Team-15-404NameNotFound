import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/login/viewmodels/welcome_view_model.dart';
// import 'package:unitrade/screens/login/views/login_view.dart';
// import 'package:unitrade/screens/login/views/register_view.dart';
import 'package:unitrade/utils/app_colors.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WelcomeViewModel(),
      child: Consumer<WelcomeViewModel>(
        builder: (context, welcomeViewModel, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Center Content
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage(
                                'lib/assets/images/unitrade_logo.png'),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            'Discover the \n best offers',
                            style: GoogleFonts.urbanist(
                              fontSize: 36,
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.color,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Get all the materials for your classes without \n feeling that you’re paying too much.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Login & Register Buttons
                    // TODO:Remove after viva voce
                    /*
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginView(),
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
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterView(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.primary900),
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    */

                    // Microsoft Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            welcomeViewModel.signInWithMicrosoft(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        icon: Image.asset(
                          'lib/assets/images/microsoft_logo.png',
                          height: 30,
                          width: 30,
                        ),
                        label: Text(
                          'Login with Microsoft',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: AppColors.primaryNeutral,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
