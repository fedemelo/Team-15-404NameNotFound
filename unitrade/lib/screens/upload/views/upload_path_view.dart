import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/screens/upload/views/upload_product_view.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:unitrade/utils/screen_time_service.dart';
import 'package:provider/provider.dart';

class UploadPathView extends StatefulWidget {
  const UploadPathView({super.key});

  @override
  UploadPathViewState createState() => UploadPathViewState();
}

class UploadPathViewState extends State<UploadPathView> {
  late ScreenTimeService screenTimeService;

  @override
  void dispose() {
    screenTimeService.stopAndRecordTime('ChooseUploadTypeView');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Start tracking time when this screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenTimeService =
          Provider.of<ScreenTimeService>(context, listen: false);
      screenTimeService.startTrackingTime();
    });

    return Scaffold(
      bottomNavigationBar: const NavBarView(initialIndex: 2),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 1.0,
        automaticallyImplyLeading: false,
        title: Text(
          'Upload Product',
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Select your path',
              style: GoogleFonts.urbanist(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Choose how you want to manage your product. You can either sell it outright or offer it for rent.',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    screenTimeService.stopAndRecordTime('ChooseUploadTypeView');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const UploadProductView(type: 'sale')),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.primary900),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                    ),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.currency_exchange_sharp),
                      const SizedBox(width: 12),
                      Text(
                        'SELL',
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
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    screenTimeService.stopAndRecordTime('ChooseUploadTypeView');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const UploadProductView(type: 'lease')),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.primary900),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                    ),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shuffle_outlined),
                      const SizedBox(width: 12),
                      Text(
                        'LIST FOR RENT',
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
