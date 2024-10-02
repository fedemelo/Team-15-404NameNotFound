import 'package:flutter/material.dart';
import 'package:unitrade/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:unitrade/pages/login/item_picker.dart';

final _firebase = FirebaseAuth.instance;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final _form = GlobalKey<FormState>();

  var _enteredName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);

      // Create user in Firebase Storage
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'uid': userCredentials.user!.uid,
        'email': _enteredEmail,
        'name': _enteredName,
      }).onError((e, _) => print("Error writing document: $e"));

      if (!mounted) return;
      // // Redirect user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ItemPicker()),
      );
    } on FirebaseAuthException catch (error) {
      // Handle Firebase authentication errors
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed')),
      );
    } catch (error) {
      // Catch any other errors
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      const SizedBox(height: 80),
                      Text(
                        'Create Account',
                        style: GoogleFonts.urbanist(
                            fontSize: 36,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 20),

                      // DESCRIPTION
                      Text(
                        'Please create your UniTrade account',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // NAME INPUT
                      Text(
                        'Name',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          labelText: 'John Smith',
                          labelStyle: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredName = value!;
                        },
                      ),
                      const SizedBox(height: 20),

                      // EMAIL INPUT
                      Text(
                        'Email',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          labelText: 'example@gmail.com',
                          labelStyle: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an email address';
                          }
                          // Regular expression for validating an email
                          String emailPattern =
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                          RegExp regex = RegExp(emailPattern);

                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          // Check if password contains @uniandes.edu.co
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@uniandes.edu.co$')
                              .hasMatch(value)) {
                            return 'Invalid email, email MUST be uniandes email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredEmail = value!;
                        },
                      ),
                      const SizedBox(height: 20),

                      // PASSWORD INPUT
                      Text(
                        'Password',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'password1234',
                          labelStyle: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a password';
                          }
                          // Check if the password has at least 8 characters
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          // Check if the password contains at least one number
                          if (!RegExp(r'\d').hasMatch(value)) {
                            return 'Password must contain at least one number';
                          }
                          // Check if the password contains at least one special character
                          if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                            return 'Password must contain at least one special character';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredPassword = value!;
                        },
                      ),
                      Text(
                        'Your password must be 8 characters or more and it must contain at least 1 number and 1 special character',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: AppColors.light400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // CREATE BUTTON AND LOGIN OPTION
                Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    children: [
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
                            'CREATE ACCOUNT',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: AppColors.primaryNeutral,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            },
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark),
                            ),
                          ),
                        ],
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
