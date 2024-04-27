import 'dart:convert'; // นำเข้าไลบรารี `dart:convert` สำหรับแปลงข้อมูล JSON

import 'package:flutter/services.dart'; // นำเข้าไลบรารี `flutter/services.dart` สำหรับเข้าถึงไฟล์ใน Assets

// เมธอด `loadFile()` สำหรับโหลดไฟล์ JSON
class JSONLoaderUtil {
  // เมธอด `loadFile()` สำหรับโหลดไฟล์ JSON
  static Future<T> loadFile<T>(
    String path, // ชื่อไฟล์ JSON
    // ฟังก์ชันสำหรับแปลงข้อมูล JSON เป็นวัตถุประเภท T
    T Function(dynamic json) builder, {
    Duration delay =
        const Duration(milliseconds: 200), // ระยะเวลาหน่วงเวลาก่อนที่จะโหลดไฟล์
  }) async {
    await Future.delayed(delay); // หน่วงเวลาตามระยะเวลาที่กำหนด
    final str = await rootBundle.loadString(path); // โหลดไฟล์ JSON เป็นสตริง
    final json = jsonDecode(str); // แปลงสตริง JSON เป็นวัตถุ JSON
    return builder(json); // คืนค่าวัตถุ JSON ที่แปลงแล้ว
  }
}
