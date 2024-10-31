import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/login/views/loading_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unitrade/utils/connectivity_service.dart';
import 'package:unitrade/utils/firebase_queue_service.dart';
import 'package:unitrade/utils/firebase_retry_service.dart';
import 'package:unitrade/utils/theme_provider.dart';
import 'utils/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:unitrade/utils/crash_manager.dart';
import 'package:unitrade/utils/product_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('firebaseQueuedRequests');

  // Create instances of the services
  final connectivityService = ConnectivityService();
  final queueService = FirebaseQueueService();
  
  // Instantiate the FirebaseRetryService to listen for connectivity changes
  FirebaseRetryService(connectivityService, queueService);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ProductService.instance.loadProductsInBackground();

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
