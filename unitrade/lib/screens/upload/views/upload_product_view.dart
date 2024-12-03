import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/views/nav_bar_view.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:intl/intl.dart';
import '../viewmodels/upload_product_viewmodel.dart';

class UploadProductView extends StatelessWidget {
  final String type;

  const UploadProductView({super.key, required this.type});

  // Method to get the title based on form type
  String _getTitle() {
    return type == 'sale' ? 'Sale' : 'Lease';
  }

  // Method to check if form type is lease
  bool _isLeaseForm() {
    return type == 'lease';
  }

  // Dialog to pick image from gallery or camera
  void showPickerDialog(
      BuildContext context, UploadProductViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  viewModel.pickImage();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  viewModel.takePhoto();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Decorator to build input fields
  Widget _buildTextInput({
    required String label,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(
          fontSize: 16,
          color: const Color(0xFF6F6F6F),
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 178, 178, 178)),
        ),
        errorStyle: GoogleFonts.urbanist(),
      ),
      style: GoogleFonts.urbanist(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }

  // Price formatter to add commas and dollar sign
  static TextInputFormatter priceFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String text = newValue.text;

      // Remove non-digit characters to clean input
      text = text.replaceAll(RegExp(r'[^\d]'), '');

      if (text.isEmpty) {
        return newValue.copyWith(text: '');
      }

      // Format the number with dots for thousands and add dollar sign
      final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
      String newText = formatter.format(int.parse(text));

      // Replace commas with dots
      newText = newText.replaceAll(',', '.');

      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    });
  }

  Future<bool> _showQueueFullModal(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text("Upload Queue Full"),
                ],
              ),
              content: const Text(
                "No internet connection. A product is already waiting to upload. Connect to the internet to complete the upload, or replace the existing product with this one.",
                style: TextStyle(fontSize: 15),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false on dismiss
                  },
                  child: const Text("Dismiss",
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true on replace
                  },
                  child: const Text("Replace",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed without a selection
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UploadProductViewModel(
        type: type,
        context: context,
        onQueueFullModal: _showQueueFullModal,
      ),
      child: Scaffold(
        bottomNavigationBar: const NavBarView(initialIndex: 1),
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
        body: Consumer<UploadProductViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        _getTitle(),
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // NAME INPUT
                      _buildTextInput(
                        label: 'Name',
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Please enter a name for the product'
                                : null,
                        onSaved: viewModel.onNameSaved,
                      ),
                      const SizedBox(height: 28),

                      // DESCRIPTION INPUT
                      _buildTextInput(
                        label: 'Description',
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Please enter a description for the product'
                                : null,
                        onSaved: viewModel.onDescriptionSaved,
                      ),
                      const SizedBox(height: 28),

                      // PRICE INPUT
                      _buildTextInput(
                        label: 'Price (COP)',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a price for the product';
                          }

                          try {
                            if (int.parse(
                                    value.replaceAll(RegExp(r'[^\d]'), '')) >
                                90000000) {
                              return 'The price cannot exceed a reasonable amount';
                            }
                          } catch (e) {
                            return null;
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          String rawValue =
                              newValue!.replaceAll(RegExp(r'[^\d]'), '');
                          viewModel.onPriceSaved(rawValue);
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          priceFormatter(),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // RENTAL PERIOD (Lease form only)
                      if (_isLeaseForm())
                        Column(
                          children: [
                            _buildTextInput(
                              label: 'Rental Period (days)',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter the rental period for the product';
                                }
                                if (int.parse(value) > 365) {
                                  return 'The rental period cannot exceed a year';
                                }
                                return null;
                              },
                              onSaved: viewModel.onRentalPeriodSaved,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),

                      // CONDITION INPUT
                      _buildTextInput(
                        label: 'Condition',
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Please enter the condition of the product'
                                : null,
                        onSaved: viewModel.onConditionSaved,
                      ),
                      const SizedBox(height: 48),

                      // IMAGE SECTION
                      Center(
                        child: Column(
                          children: [
                            viewModel.selectedImage == null
                                ? GestureDetector(
                                    onTap: () =>
                                        showPickerDialog(context, viewModel),
                                    child: Container(
                                      width: 600,
                                      padding: const EdgeInsets.all(40),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 237, 236, 236),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.image_search_rounded,
                                            size: 48,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Upload Image',
                                            style: GoogleFonts.urbanist(
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.file(
                                          viewModel.selectedImage!,
                                          width: 160,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: GestureDetector(
                                          onTap: viewModel.removeImage,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 48),

                            // UPLOAD BUTTON
                            ElevatedButton(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () => viewModel.submit(context),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    AppColors.primary900),
                                padding:
                                    WidgetStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 18),
                                ),
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    Colors.white),
                              ),
                              child: viewModel.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.file_upload_outlined),
                                        const SizedBox(width: 14),
                                        Text(
                                          'UPLOAD PRODUCT',
                                          style: GoogleFonts.urbanist(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
