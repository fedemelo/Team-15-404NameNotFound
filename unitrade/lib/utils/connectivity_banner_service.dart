import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:unitrade/utils/firebase_service.dart';

class ConnectivityBannerService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  late StreamSubscription<InternetStatus> _connectionSubscription;
  final FirebaseAuth _firebaseAuth = FirebaseService.instance.auth;

  ConnectivityBannerService(this.scaffoldMessengerKey);

  void startMonitoring(themeData) {
    _connectionSubscription =
        InternetConnection().onStatusChange.listen((status) {
      final hasConnection = status == InternetStatus.connected;
      print("Connection status: $status");
      final user = _firebaseAuth.currentUser;
      if (!hasConnection && user != null) {
        Future.delayed(const Duration(seconds: 1), () {
          _showConnectivityBanner(themeData);
        });
      } else {
        _hideConnectivityBanner();
      }
    });
  }

  void _showConnectivityBanner(themeData) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Container(
          height: 18,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 15, color: themeData.iconTheme.color),
              const SizedBox(width: 8),
              const Text(
                "No Internet Connection",
                style: TextStyle(),
              ),
            ],
          ),
        ),
        duration: const Duration(days: 1),
      ),
    );
  }

  void _hideConnectivityBanner() {
    scaffoldMessengerKey.currentState?.clearSnackBars();
  }

  void stopMonitoring() {
    _connectionSubscription.cancel();
  }
}
