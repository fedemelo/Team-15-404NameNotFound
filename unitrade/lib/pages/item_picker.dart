import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitrade/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemPicker extends StatefulWidget {
  const ItemPicker({super.key});

  @override
  _ItemPickerState createState() => _ItemPickerState();
}

class _ItemPickerState extends State<ItemPicker> {
  List<String> selectedCategories = [];

  final List<String> categories = [
    'TEXTBOOKS',
    'STUDY GUIDES',
    'ELECTRONICS',
    'LAPTOPS & TABLETS',
    'CALCULATORS',
    'CHARGERS',
    'LAB MATERIALS',
    'NOTEBOOKS',
    'ART & DESIGN',
    'ROBOTIC KITS',
    '3D PRINTING',
    'UNIFORMS',
    'SPORTS',
    'MUSICAL INSTRUMENTS',
  ];

  Future<void> _submit() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'categories': selectedCategories,
      });

      if (!mounted) return;
      // // Redirect user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ItemPicker()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNeutral,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TITLE
              Text(
                'We want to \n know you better',
                textAlign: TextAlign.center,
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
                'Choose the items you are interested in',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 50,
              ),

              // ITEM CHOOSER
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: categories.map((category) {
                  final isSelected = selectedCategories.contains(category);

                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primaryNeutral
                          : AppColors.primary900,
                    ),
                    backgroundColor: AppColors.primaryNeutral,
                    selectedColor: AppColors.primary900,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: AppColors.primary900),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedCategories.add(category);
                        } else {
                          selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 50,
              ),

              // DISCOVER BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'DISCOVER',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: AppColors.primaryNeutral,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
