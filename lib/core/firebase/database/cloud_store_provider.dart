// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseCloudStoreProvider = Provider<FirebaseCloudStore>((ref) {
  return FirebaseCloudStore(
    firestore: FirebaseFirestore.instance,
  );
});

/// this is a wrapper class for FirebaseFirebaseDatabase.
class FirebaseCloudStore {
  final FirebaseFirestore firestore;

  // กำหนดค่า FirebaseFirestore
  FirebaseCloudStore({
    required this.firestore,
  });

  // เมธอดสำหรับดึง CollectionReference จาก Firebase Firestore โดยระบุชื่อ Collection (table)
  CollectionReference collection(String table) {
    return firestore.collection(table);
  }
}
