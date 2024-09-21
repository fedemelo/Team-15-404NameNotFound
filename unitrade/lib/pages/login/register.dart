import 'package:flutter/material.dart';
import 'package:unitrade/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNeutral,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  const SizedBox(height: 80),
                  Text(
                    'Create Account',
                    style: GoogleFonts.urbanist(
                        fontSize: 36,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),

                  // DESCRIPTION
                  Text(
                    'Please create your UniTrade account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // NAME INPUT
                  Text(
                    'Name',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'John Smith',
                      labelStyle: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w400,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // EMAIL INPUT
                  Text(
                    'Email',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'example@gmail.com',
                      labelStyle: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w400,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // PASSWORD INPUT
                  Text(
                    'Password',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'password1234',
                      labelStyle: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w400,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Your password must be 8 characters or more and it must contain at least 1 number and 1 special character',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: AppColors.light400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // CREATE BUTTON AND LOGIN OPTION
              Container(
                margin: const EdgeInsets.only(bottom: 60),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement login functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          'CREATE ACCOUNT',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: AppColors.primaryNeutral,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
