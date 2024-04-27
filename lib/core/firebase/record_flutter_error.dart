import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// ฟังก์ชันนี้ใช้เพื่อบันทึกข้อมูลเกี่ยวกับข้อผิดพลาดใน Flutter framework ไปยัง Firebase Crashlytics
/// ถ้าการรวบรวมข้อมูลเกี่ยวกับข้อผิดพลาดนั้นถูกเปิดใช้งาน
Future<void> recordFlutterError() async {
  // ตรวจสอบว่าการรวบรวมข้อมูลเกี่ยวกับข้อผิดพลาดถูกเปิดใช้งานหรือไม่
  if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
    /// Pass all uncaught errors from the flutter framework to Crashlytics.
    ///
    /// By overriding FlutterError.onError with FirebaseCrashlytics.instance.recordFlutterError,
    /// it will automatically catch all errors that are thrown within the Flutter framework.

    /// กำหนดค่า FlutterError.onError ด้วยฟังก์ชัน FirebaseCrashlytics.instance.recordFlutterError
    /// เพื่อบันทึกข้อมูลข้อผิดพลาดที่เกิดขึ้นภายใน Flutter framework โดยอัตโนมัติ
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
}
