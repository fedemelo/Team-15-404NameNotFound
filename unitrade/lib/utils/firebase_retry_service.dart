import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:unitrade/utils/firebase_queued_request.dart';
import 'firebase_queue_service.dart';
import 'connectivity_service.dart';

class FirebaseRetryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivityService;
  final FirebaseQueueService _queueService;

  FirebaseRetryService(this._connectivityService, this._queueService) {
    _connectivityService.connectivityStream
    .listen((List<ConnectivityResult> result) async {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        _retryQueuedRequests();
        
      }
    });
  }

  Future<void> _retryQueuedRequests() async {
    List<FirebaseQueuedRequest> requests = _queueService.getQueuedRequests();
    print('Retrying ${requests.length} requests');
    for (int i = 0; i < requests.length; i++) {
      final request = requests[i];
      try {
        await _executeRequest(request);
        _queueService.clearRequest(i); // Remove the request if successful
      } catch (e) {
        // Handle retry failure, logging, etc.
      }
    }
  }

  Future<void> _executeRequest(FirebaseQueuedRequest request) {
    switch (request.operation) {
      case 'update':
        return _firestore
            .collection(request.collectionPath)
            .doc(request.documentId)
            .update(request.data);
      case 'set':
        return _firestore
            .collection(request.collectionPath)
            .doc(request.documentId)
            .set(request.data);
      default:
        throw Exception('Unsupported operation');
    }
  }
}
