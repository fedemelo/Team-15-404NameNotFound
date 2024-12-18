import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // This method checks if the device has an active internet connection (Wifi or mobile) and returns a boolean value
  Future<bool> checkConnectivity() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await _connectivity.checkConnectivity();
      return connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi);
    } catch (e) {
      if (kDebugMode) {
        print("Error checking connectivity: $e");
      }
      return false;
    }
  }

  // Stream to monitor connectivity changes
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}
