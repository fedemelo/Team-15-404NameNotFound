import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unitrade/utils/firebase_service.dart';

class AnalyticService {
  
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

    void logSignInStats(User user) {
    final DateTime currentDate = DateTime.now();
    final int hour = currentDate.hour; // 0 to 23
    final int weekday = (currentDate.weekday % 7); // 0 to 6 (0 = Sunday)

    // Reference to the "time_engagement" document in the "analytics" collection
    final DocumentReference statsRef =
        _firestore.collection('analytics').doc('time_engagement');

    // Field path representing the counter for the current hour and weekday
    final String fieldPath = 'day_$weekday.hour_$hour';

    // Increment the sign-in counter for the current hour and weekday
    statsRef.update({
      fieldPath: FieldValue.increment(1),
    }).then((_) {
      print('Successfully updated sign-in stats');
    }).catchError((error) {
      print('Error updating sign-in stats: $error');
    });
  }

}