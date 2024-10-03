import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/pages/home/models/filter_model.dart';
import 'package:unitrade/pages/home/viewmodels/filter_section_viewmodel.dart';

class FilterSectionView extends StatelessWidget {
  final FilterModel actualFilters;
  final Function(FilterModel) onUpdateFilters;

  FilterSectionView({
    required this.actualFilters,
    required this.onUpdateFilters,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterSectionViewModel(actualFilters),
      child: Consumer<FilterSectionViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Minimum Price
                TextField(
                  controller: viewModel.minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Minimum Price',
                  ),
                ),
                SizedBox(height: 8.0),
                // Maximum Price
                TextField(
                  controller: viewModel.maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Maximum Price',
                  ),
                ),
                SizedBox(height: 16.0),
                // Minimum Rate
                TextField(
                  controller: viewModel.minRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Minimum Rate',
                  ),
                ),
                SizedBox(height: 8.0),
                // Maximum Rate
                TextField(
                  controller: viewModel.maxRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Maximum Rate',
                  ),
                ),
                SizedBox(height: 16.0),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        viewModel.clearFilters();
                        onUpdateFilters(FilterModel()); // Limpia los filtros
                      },
                      child: Text('Clear'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final updatedFilters = viewModel.applyFilters();
                        onUpdateFilters(updatedFilters);
                        Navigator.pop(context); // Cierra el diálogo o la pantalla
                      },
                      child: Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
