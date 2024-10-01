import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/filter.dart';

class FilterWidget extends StatefulWidget {
  final Filters actualFilters;
  final Function(Filters) onUpdateFilters;

  FilterWidget({
    required this.actualFilters,
    required this.onUpdateFilters,
  });

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late TextEditingController _minRateController;
  late TextEditingController _maxRateController;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(text: widget.actualFilters.minPrice?.toString());
    _maxPriceController = TextEditingController(text: widget.actualFilters.maxPrice?.toString());
    _minRateController = TextEditingController(text: widget.actualFilters.minRate?.toString());
    _maxRateController = TextEditingController(text: widget.actualFilters.maxRate?.toString());
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minRateController.dispose();
    _maxRateController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    Filters updatedFilters = Filters(
      minPrice: double.tryParse(_minPriceController.text),
      maxPrice: double.tryParse(_maxPriceController.text),
      minRate: double.tryParse(_minRateController.text),
      maxRate: double.tryParse(_maxRateController.text),
    );

    widget.onUpdateFilters(updatedFilters);
    Navigator.pop(context); 
  }

  void _clearFilters() {
    _minPriceController.clear();
    _maxPriceController.clear();
    _minRateController.clear();
    _maxRateController.clear();

    widget.onUpdateFilters(Filters());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Minimum Price
          TextField(
            controller: _minPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Minimum Price',
            ),
          ),
          SizedBox(height: 8.0),
          // Maximum Price
          TextField(
            controller: _maxPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Maximum Price',
            ),
          ),
          SizedBox(height: 16.0),
          // Minimum Rate
          TextField(
            controller: _minRateController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Minimum Rate',
            ),
          ),
          SizedBox(height: 8.0),
          // Maximum Rate
          TextField(
            controller: _maxRateController,
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
                onPressed: _clearFilters,
                child: Text('Clear'),
              ),
              ElevatedButton(
                onPressed: _applyFilters,
                child: Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
