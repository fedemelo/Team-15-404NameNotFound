import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:unitrade/utils/app_colors.dart';

class ConnectivityBannerService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  late StreamSubscription<InternetStatus> _connectionSubscription;

  ConnectivityBannerService(this.scaffoldMessengerKey);

  void startMonitoring() {
    _connectionSubscription =
        InternetConnection().onStatusChange.listen((status) {
      final hasConnection = status == InternetStatus.connected;

      if (!hasConnection) {
        _showConnectivityBanner();
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
              // Sett the color to the background color of the app\
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
}
