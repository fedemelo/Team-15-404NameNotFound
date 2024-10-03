import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/pages/login/viewmodels/register_viewmodel.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_view.dart';


class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: Consumer<RegisterViewModel>(
          builder: (context, registerViewModel, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.primaryNeutral,
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: registerViewModel.formKey,
                    child: Column(
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
                        TextFormField(
                          onChanged: registerViewModel.setName,
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                            hintText: 'John Smith',
                            labelStyle: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          validator: registerViewModel.validateName,
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
                        TextFormField(
                          onChanged: registerViewModel.setEmail,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                            hintText: 'example@gmail.com',
                            labelStyle: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          validator: registerViewModel.validateEmail,
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
                        TextFormField(
                          obscureText: true,
                          onChanged: registerViewModel.setPassword,
                          decoration: InputDecoration(
                            hintText: 'password1234',
                            labelStyle: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          validator: registerViewModel.validatePassword,
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
                  ),
                  if (registerViewModel.errorMessage != null)
                    Text(
                      registerViewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),
              
                  // CREATE BUTTON
                  Container(
                    margin: const EdgeInsets.only(bottom: 60),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: registerViewModel.isLoading
                                ? null
                                : () => registerViewModel.register(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: registerViewModel.isLoading
                                ? const CircularProgressIndicator(
                                    color: AppColors.primaryNeutral,
                                  )
                                : Text(
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
              
                        // LOGIN OPTION
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
                                      builder: (context) =>
                                          const LoginView()),
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
      }),
    );
  }
}
