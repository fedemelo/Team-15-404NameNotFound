import 'package:hive/hive.dart';
import 'firebase_queued_request.dart';

class FirebaseQueueService {
  final Box _box = Hive.box('firebaseQueuedRequests');

  void addRequestToQueue(FirebaseQueuedRequest request) {
    _box.add(request.toMap());
  }

  List<FirebaseQueuedRequest> getQueuedRequests() {
    return _box.values
        .map((item) => FirebaseQueuedRequest.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  void clearRequest(int index) {
    _box.deleteAt(index);
  }

  void clearAll() {
    _box.clear();
  }
}
