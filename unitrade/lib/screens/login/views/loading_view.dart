import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/screens/login/views/welcome_view.dart';
import 'package:unitrade/utils/screen_time_service.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  late ScreenTimeService screenTimeService;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenTimeService =
          Provider.of<ScreenTimeService>(context, listen: false);
      screenTimeService.startTrackingTime();
    });

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeView()),
      );
    });
  }

  @override
  void dispose() {
    // Stop tracking time without accessing context
    screenTimeService.stopAndRecordTime("SplashScreen");
    super.dispose();
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
