import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/screens/upload/views/upload_product_view.dart';
import 'package:unitrade/utils/app_colors.dart';

class UploadPathView extends StatelessWidget {
  const UploadPathView({super.key});

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
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
