import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitrade/pages/login/loading_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.urbanistTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const LoadingView(),
    );
  }
}
