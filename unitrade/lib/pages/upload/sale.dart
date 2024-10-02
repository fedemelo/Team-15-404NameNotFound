import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unitrade/pages/home/home.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Sale extends StatefulWidget {
  const Sale({super.key});

  @override
  State<Sale> createState() => _SaleState();
}

class _SaleState extends State<Sale> {
  // Form data
  final _form = GlobalKey<FormState>();
  var _name = '';
  var _description = '';
  var _price = '';
  var _condition = '';
  var _imageUrl = '';

  // Image data
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  // Firebase storage
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user
  final _user = FirebaseAuth.instance.currentUser;

  // Image picker function
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Take photo function
  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Show picker dialog
  void _showPickerDialog(BuildContext context) {
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
                  _pickImage();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _takePhoto();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Show success message
  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product uploaded successfully'),
      ),
    );
  }

  // Upload product & image to Firebase
  void _submit() async {
    _form.currentState!.save();

    // First - Validate form
    if (kDebugMode) {
      print('Name: $_name');
      print('Description: $_description');
      print('Price: $_price');
      print('Condition: $_condition');
      print('Form: ${_form.currentState}');
      print('User email: ${_user!.email}');
    }

    final isValid = _form.currentState!.validate();
    if (!isValid) {
      if (kDebugMode) {
        print('Form is not valid');
      }
      return;
    }

    // Second - Upload image to Firebase Storage
    try {
      if (_selectedImage != null) {
        const uuid = Uuid();
        final String fileName = 'images/${uuid.v4()}.jpg';
        await _storage.ref(fileName).putFile(_selectedImage!);
        _imageUrl = await _storage.ref(fileName).getDownloadURL();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    // Third - Upload product data to Firestore
    var data = {
      'user_id': _user!.uid,
      'type': 'sale',
      'name': _name,
      'description': _description,
      'price': _price,
      'condition': _condition,
      'categories': ['TEXTBOOKS', 'CHARGERS'],
    };
    if (_imageUrl.isNotEmpty) {
      data['image_url'] = _imageUrl;
    }

    final id = const Uuid().v4();
    await _firestore.collection('products').doc(id).set(data);

    // Fourth - Show success message
    _showSuccessMessage();

    // Five - Navigate back to home
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // TITLE
                Text(
                  'Sale',
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // NAME INPUT
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: const Color(0xFF6F6F6F),
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 178, 178, 178)),
                    ),
                    errorStyle: GoogleFonts.urbanist(),
                  ),
                  style: GoogleFonts.urbanist(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name for the product';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                const SizedBox(height: 28),

                // DESCRIPTION INPUT
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: const Color(0xFF6F6F6F),
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 178, 178, 178)),
                    ),
                    errorStyle: GoogleFonts.urbanist(),
                  ),
                  style: GoogleFonts.urbanist(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description for the product';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                const SizedBox(height: 28),

                // PRICE INPUT
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: const Color(0xFF6F6F6F),
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 178, 178, 178)),
                    ),
                    errorStyle: GoogleFonts.urbanist(),
                  ),
                  style: GoogleFonts.urbanist(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a price for the product';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _price = value!;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 28),

                // CONDITION INPUT
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Condition',
                    labelStyle: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: const Color(0xFF6F6F6F),
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 178, 178, 178)),
                    ),
                    errorStyle: GoogleFonts.urbanist(),
                  ),
                  style: GoogleFonts.urbanist(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the condition of the product';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _condition = value!;
                  },
                ),
                const SizedBox(height: 48),

                // IMAGE SELECTION & UPLOAD BUTTON
                Center(
                  child: Column(
                    children: [
                      // SELECT IMAGE ZONE & IMAGE PREVIEW
                      _selectedImage == null
                          // Show select image zone
                          ? GestureDetector(
                              onTap: () {
                                _showPickerDialog(context);
                              },
                              child: Container(
                                width: 600,
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 237, 236, 236),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.image_search_rounded,
                                      size: 48,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Select image',
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
                          // Show image preview
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.file(
                                    File(_selectedImage!.path),
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      _selectedImage = null;
                                    }),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
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
                        onPressed: _submit,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            AppColors.primary900,
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 18),
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                        child: Row(
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
