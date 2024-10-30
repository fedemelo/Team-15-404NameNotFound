class FirebaseQueuedRequest {
  final String collectionPath;
  final String documentId;
  final Map<String, dynamic> data;
  final String operation; // 'update', 'set', etc.

  FirebaseQueuedRequest({
    required this.collectionPath,
    required this.documentId,
    required this.data,
    required this.operation,
  });

  Map<String, dynamic> toMap() {
    return {
      'collectionPath': collectionPath,
      'documentId': documentId,
      'data': data,
      'operation': operation,
    };
  }

  factory FirebaseQueuedRequest.fromMap(Map<String, dynamic> map) {
    return FirebaseQueuedRequest(
      collectionPath: map['collectionPath'],
      documentId: map['documentId'],
      data: Map<String, dynamic>.from(map['data']),
      operation: map['operation'],
    );
  }
}
