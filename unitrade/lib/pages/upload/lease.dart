import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Lease extends StatefulWidget {
  const Lease({super.key});

  @override
  State<Lease> createState() => _LeaseState();
}

class _LeaseState extends State<Lease> {
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
    );
  }
}
