import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:unitrade/utils/app_colors.dart';
import 'package:unitrade/utils/firebase_service.dart';

class ConnectivityBannerService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  late StreamSubscription<InternetStatus> _connectionSubscription;
  final FirebaseAuth _firebaseAuth = FirebaseService.instance.auth;

  ConnectivityBannerService(this.scaffoldMessengerKey);

  void startMonitoring() {
    _connectionSubscription =
        InternetConnection().onStatusChange.listen((status) {
      final hasConnection = status == InternetStatus.connected;
      final user = _firebaseAuth.currentUser;
      if (!hasConnection && user != null) {
        Future.delayed(const Duration(seconds: 1), () {
          _showConnectivityBanner();
        });
      } else {
        _hideConnectivityBanner();
      }
    });
  }

  void _showConnectivityBanner() {
    scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 20,
              color: AppColors.primary900,
            ),
            SizedBox(width: 8),
            Text(
              "No Internet Connection",
            ),
          ],
        ),
        duration: Duration(days: 1),
      ),
    );
  }

  void _hideConnectivityBanner() {
    scaffoldMessengerKey.currentState?.clearSnackBars();
  }

  void stopMonitoring() {
    _connectionSubscription.cancel();
  }

  // void enableMonitoring() {
  //   _shouldMonitor = true;
  // }

  // void disableMonitoring() {
  //   _shouldMonitor = false;
  // }
}
