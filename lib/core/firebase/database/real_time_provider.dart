import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseRealTimeProvider = Provider<FirebaseRealTime>((ref) {
  return FirebaseRealTime(
    realTime: FirebaseDatabase.instance,
  );
});

// คลาส FirebaseRealTime ที่ใช้เพื่อครอบคลุมการเข้าถึง Firebase Realtime Database
class FirebaseRealTime {
  final FirebaseDatabase realTime;

  // กำหนดค่า realTime ที่เป็น FirebaseDatabase instance เมื่อสร้าง FirebaseRealTime
  FirebaseRealTime({
    required this.realTime,
  });

  // เมธอด ref ที่ให้การเข้าถึง DatabaseReference ของ Firebase Realtime Database
  DatabaseReference ref(String path) {
    return realTime.ref(path);
  }
}
