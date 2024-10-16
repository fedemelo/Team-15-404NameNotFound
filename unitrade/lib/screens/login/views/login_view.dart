import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/screens/login/viewmodels/login_viewmodel.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/screens/login/views/register_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => LoginViewModel(),
        child: Consumer<LoginViewModel>(
          builder: (context, loginViewModel, child) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: SafeArea(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TITLE
                            const SizedBox(height: 80),
                            Text(
                              'Log in',
                              style: GoogleFonts.urbanist(
                                  fontSize: 36,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.color,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 20),

                            // DESCRIPTION
                            Text(
                              'Please sign up to your UniTrade account',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 60),

                            // EMAIL INPUT
                            Text(
                              'Email',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              onChanged: loginViewModel.setEmail,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: 'example@gmail.com',
                                labelStyle: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                  fontWeight: FontWeight.w400,
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
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              obscureText: true,
                              onChanged: loginViewModel.setPassword,
                              decoration: InputDecoration(
                                hintText: 'password1234',
                                labelStyle: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (loginViewModel.errorMessage != null) ...[
                        Text(
                          loginViewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],

                      // LOGIN BUTTON
                      Container(
                        margin: const EdgeInsets.only(bottom: 60),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await loginViewModel.login();
                                  if (loginViewModel.errorMessage == null) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const HomeView(),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary900,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: loginViewModel.isLoading
                                    ? const CircularProgressIndicator(
                                        color: AppColors.primaryNeutral,
                                      )
                                    : Text(
                                        'LOG IN',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 16,
                                          color: AppColors.primaryNeutral,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // CREATE ACCOUNT TEXT
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("New to the app?"),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterView()),
                                    );
                                  },
                                  child: Text(
                                    "Create Account",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color),
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
          },
        ));
  }
}
