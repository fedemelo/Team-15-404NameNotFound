import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:unitrade/utils/firebase_service.dart';

class CrashManager {

  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  Future<void> reportCrashToFirestore(dynamic error,
      StackTrace stackTrace) async {
    try {
      String osName;
      String osVersion;

      if (Platform.isAndroid) {
        osName = 'android';
        osVersion = await getAndroidVersion();
      } else if (Platform.isIOS) {
        osName = 'iOS';
        osVersion = await getIosVersion();
      } else {
        osName = 'other';
        osVersion = 'unknown';
      }

      String documentName = '$osName $osVersion';

      final DocumentReference crashDoc = _firestore
          .collection('analytics')
          .doc('crashes')
          .collection('all')
          .doc(documentName);

      final docSnapshot = await crashDoc.get();

      if (docSnapshot.exists) {
        await crashDoc.update({
          'crashes': FieldValue.increment(1),
        });
      } else {
        await crashDoc.set({
          'OS': osName,
          'version': osVersion,
          'crashes': 1,
        });
      }
    } catch (e) {
      print("Error reporting crash to Firestore: $e");
    }
  }

  Future<String> getAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.release;
  }

  Future<String> getIosVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.systemVersion;
  }
}

