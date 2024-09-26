import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/pages/upload/lease.dart';
import 'package:unitrade/pages/upload/sale.dart';
import 'package:unitrade/app_colors.dart';

class Upload extends StatelessWidget {
  const Upload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                color: Colors.black87,
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
                        builder: (context) => const Sale(),
                      ),
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
                      const SizedBox(width: 14),
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
                const SizedBox(width: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Lease(),
                      ),
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
                      const SizedBox(width: 14),
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
