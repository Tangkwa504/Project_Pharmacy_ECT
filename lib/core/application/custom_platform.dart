import 'dart:io';

import 'package:flutter/material.dart';

class CustomPlatform {
  CustomPlatform._();

  // เก็บข้อมูลเกี่ยวกับแพลตฟอร์มและภาษา
  static TargetPlatform? _targetPlatform;
  static String? _localeName;

  // ฟังก์ชั่นเพื่ออัปเดตข้อมูลจาก BuildContext
  static void refresh(BuildContext context) {
    setPlatform(Theme.of(context).platform);
    setLocaleName(Platform.localeName);
  }

  // ฟังก์ชั่นเพื่อตั้งค่าแพลตฟอร์ม
  static void setPlatform(TargetPlatform targetPlatform) {
    _targetPlatform = targetPlatform;
  }

  // ฟังก์ชั่นเพื่อตั้งค่าภาษา
  static void setLocaleName(String localeName) {
    _localeName = localeName;
  }

  // ตรวจสอบว่าเป็นแพลตฟอร์ม iOS หรือไม่
  static bool get isIOS {
    return _targetPlatform == TargetPlatform.iOS;
  }

  // ตรวจสอบว่าเป็นแพลตฟอร์ม Android หรือไม่
  static bool get isAndroid {
    return _targetPlatform == TargetPlatform.android;
  }

  // รับค่า localeName
  static String get localeName {
    assert(_localeName != null);
    return _localeName!;
  }

  // สลับระหว่างค่า iOS และ Android ตามแพลตฟอร์มปัจจุบัน
  static T switchPlatform<T>({required T iOS, required T android}) {
    assert(_targetPlatform != null);
    if (isIOS) {
      return iOS;
    }
    return android;
  }

  // ตรวจสอบว่าในโหมดทดสอบหรือไม่
  static bool get isTest {
    return Platform.environment.containsKey('FLUTTER_TEST');
  }
}
