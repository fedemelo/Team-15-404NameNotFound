import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/login/views/loading_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unitrade/utils/theme_provider.dart';
import 'utils/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:unitrade/utils/crash_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final crashManager = CrashManager();
  FlutterError.onError = (FlutterErrorDetails details) async {
    await crashManager.reportCrashToFirestore(details.exception, details.stack ?? StackTrace.empty);
  };

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: const LoadingView(),
    );
  }
}
