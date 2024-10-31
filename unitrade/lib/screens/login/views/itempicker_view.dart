import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/views/home_view.dart';
import 'package:unitrade/screens/login/viewmodels/itempicker_viewmodel.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ItempickerView extends StatelessWidget {
  const ItempickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ItemPickerViewModel(),
      child: Consumer<ItemPickerViewModel>(
          builder: (context, itemPickerViewModel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    // TITLE
                    Text(
                      'We want to \n know you better',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                          fontSize: 36,
                          color:
                              Theme.of(context).textTheme.headlineLarge?.color,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      width: double.infinity,
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // MAJOR SELECT
                            Text(
                              'Major',
                              style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.color,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: itemPickerViewModel.selectedMajor,
                                hint: const Text("Select a major"),
                                items: itemPickerViewModel.majors
                                    .map((major) => DropdownMenuItem(
                                          value: major,
                                          child: Text(major),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  itemPickerViewModel.setMajor(value);
                                },
                              ),
                            ),

                            // Error message if a major is not selected
                            if (itemPickerViewModel.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  itemPickerViewModel.errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),

                            // SEMESTER SELECT
                            Text(
                              'Semester',
                              style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.color,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: itemPickerViewModel.selectedSemester,
                                items: itemPickerViewModel.semesters
                                    .map((semester) => DropdownMenuItem(
                                          value: semester,
                                          child: Text(semester),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    itemPickerViewModel.setSemester(value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // ITEM CHOOSER
                    Text(
                      'Choose the items you are interested in',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (itemPickerViewModel.isLoading)
                      const CircularProgressIndicator()
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children:
                            itemPickerViewModel.categories.map((category) {
                          final isSelected = itemPickerViewModel
                              .selectedCategories
                              .contains(category);
                          return ChoiceChip(
                            label: Text(
                              category,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            selected: isSelected,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.primaryNeutral
                                  : Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.primaryNeutral
                                      : AppColors.primary900,
                            ),
                            checkmarkColor: AppColors.primaryNeutral,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            selectedColor: AppColors.primary900,
                            shape: RoundedRectangleBorder(
                              side:
                                  const BorderSide(color: AppColors.primary900),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onSelected: (bool selected) {
                              itemPickerViewModel.toggleCategory(category);
                            },
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 50),

                    // DISCOVER BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await itemPickerViewModel.submit(context);
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
                    const SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
