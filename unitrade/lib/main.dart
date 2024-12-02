import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unitrade/screens/home/models/product_model.dart';
import 'package:unitrade/screens/login/views/loading_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unitrade/utils/connectivity_banner_service.dart';
import 'package:unitrade/utils/connectivity_service.dart';
import 'package:unitrade/utils/firebase_queue_service.dart';
import 'package:unitrade/utils/firebase_retry_service.dart';
import 'package:unitrade/utils/screen_time_service.dart';
import 'package:unitrade/utils/theme_provider.dart';
import 'utils/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:unitrade/utils/crash_manager.dart';
import 'package:unitrade/utils/product_service.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());

  await Hive.openBox('myOrders');
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
    await crashManager.reportCrashToFirestore(
        details.exception, details.stack ?? StackTrace.empty);
  };

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final ConnectivityBannerService connectivityBannerService =
      ConnectivityBannerService(
    scaffoldMessengerKey,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => ScreenTimeService()),
      Provider(create: (_) => connectivityBannerService),
    ],
    child: MyApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      connectivityBannerService: connectivityBannerService,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final ConnectivityBannerService connectivityBannerService;

  const MyApp({
    super.key,
    required this.scaffoldMessengerKey,
    required this.connectivityBannerService,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // connectivityBannerService.disableMonitoring();
    connectivityBannerService.startMonitoring();

    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: const LoadingView(),
    );
  }
}
