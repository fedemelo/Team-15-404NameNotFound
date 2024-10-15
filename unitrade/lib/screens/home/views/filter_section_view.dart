import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/models/filter_model.dart';
import 'package:unitrade/screens/home/viewmodels/filter_section_viewmodel.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterSectionView extends StatelessWidget {
  final FilterModel actualFilters;
  final Function(FilterModel) onUpdateFilters;
  Function(bool) selectedFilters;

  FilterSectionView({
    required this.actualFilters,
    required this.onUpdateFilters,
    required this.selectedFilters,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterSectionViewModel(actualFilters),
      child: Consumer<FilterSectionViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price range",
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        color: AppColors.secondary900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close,
                          color: AppColors.secondary900),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Min Price y Max Price en fila
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Min Price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Min Price",
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: AppColors.primary600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: viewModel.minPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Min',
                                hintStyle: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          width: 16), // Espacio entre los campos de Min y Max
                      // Max Price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Max Price",
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: AppColors.primary600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: viewModel.maxPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Max',
                                hintStyle: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Mensaje de error si los precios no son válidos
                if (viewModel.invalidPriceRange)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "The minimum price cannot be greater than the maximum price.",
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                if (viewModel.missingPriceFields)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Please enter both minimum and maximum prices.",
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Sección "Sort By"
                Text(
                  "Sort By",
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    color: AppColors.secondary900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => viewModel.updateSortBy("Rating"),
                        child: Container(
                          padding: const EdgeInsets.all(
                              3),
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[300],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: viewModel.sortBy == "Rating"
                                  ? Colors
                                      .white
                                  : Colors
                                      .transparent,
                              borderRadius: BorderRadius.circular(
                                  8),
                            ),
                            child: Center(
                              child: Text(
                                "Rating",
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => viewModel.updateSortBy("Price"),
                        child: Container(
                          padding: const EdgeInsets.all(
                              3),
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[300],
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: viewModel.sortBy == "Price"
                                  ? Colors
                                      .white
                                  : Colors
                                      .transparent,
                              borderRadius: BorderRadius.circular(
                                  8),
                            ),
                            child: Center(
                              child: Text(
                                "Price",
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text(
                      "Order:",
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: AppColors.primary600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Botón "Ascendant"
                    Expanded(
                      child: GestureDetector(
                        onTap: () => viewModel.updateSortOrder(true),
                        child: Container(
                          padding: const EdgeInsets.all(
                              3),
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[300],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: viewModel.sortAscendant
                                  ? Colors
                                      .white
                                  : Colors
                                      .transparent,
                              borderRadius: BorderRadius.circular(
                                  8),
                            ),
                            child: Center(
                              child: Text(
                                "Ascendant",
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Botón "Descendant"
                    Expanded(
                      child: GestureDetector(
                        onTap: () => viewModel.updateSortOrder(false),
                        child: Container(
                          padding: const EdgeInsets.all(
                              3),
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[300],
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: !viewModel.sortAscendant
                                  ? Colors
                                      .white
                                  : Colors
                                      .transparent,
                              borderRadius: BorderRadius.circular(
                                  8),
                            ),
                            child: Center(
                              child: Text(
                                "Descendant",
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // Botones de Reset y Apply
                Row(
                  children: [
                    // Botón "RESET"
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: AppColors.secondary900,
                            side: const BorderSide(color: AppColors.secondary900),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            viewModel.clearFilters();
                          },
                          child: const Text('RESET'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Botón "APPLY"
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !viewModel.invalidPriceRange && !viewModel.missingPriceFields
                                ? AppColors.secondary900
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: viewModel.invalidPriceRange || viewModel.missingPriceFields
                              ? null
                              : () {
                            final updatedFilters = viewModel.applyFilters(selectedFilters);
                            onUpdateFilters(updatedFilters);
                            Navigator.pop(context);
                          },
                          child: const Text('APPLY'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
