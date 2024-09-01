import 'package:cloud_firestore/cloud_firestore.dart';
class CameraIdApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to retrieve camera details as a stream with sorting by timestamp
  Stream<QuerySnapshot> getCameraDetailsStream() {
    return _firestore
        .collection('Camera Informations')
        .orderBy('timestamp', descending: true)  
        .snapshots();
        
  }

  // Method to retrieve camera details as a future (one-time read)
  Future<QuerySnapshot> getCameraDetailsOnce() {
    return _firestore
        .collection('Camera Informations')
        .orderBy('timestamp', descending: true)  
        .get();
  }
}

