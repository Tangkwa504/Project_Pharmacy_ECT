import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:multiple_result/multiple_result.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:pharmacy_online/core/error/failure.dart';

final baseUtilsProvider = Provider<BaseUtils>(
  (ref) => BaseUtils(),
);

class BaseUtils {
  // void launchURL(String? url) async {
  //   if (url != null) {
  //     final _url = Uri.parse(url);
  //     //  check that url can open in browser.
  //     if (await canLaunchUrl(_url)) {
  //       await launchUrl(_url);
  //     } else {
  //       throw 'Could not launch $url';
  //     }
  //   }
  // }

  // ตรวจสอบว่าไฟล์นามสกุลที่อนุญาต
  bool allowFileExtension(
    String file,
    List<String> allowFiles,
  ) {
    final _file = p.extension(file); // ดึงนามสกุลไฟล์
    return allowFiles
        .contains(_file); // ตรวจสอบว่านามสกุลอยู่ในรายการที่อนุญาตหรือไม่
  }

  // แปลง enum ให้อยู่ในรูป snake_case
  String? enumToStringSnakeCase(enumValue) {
    if (enumValue == null) return null;

    // แยก enum เป็นชื่อคลาสและชื่อตัวแปร
    String enumString = enumValue.toString().split('.')[1];
    // แปลงตัวอักษรตัวใหญ่เป็นตัวเล็กและใส่ "_" คั่น
    return enumString
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)}',
        )
        .toLowerCase();
  }

  // ตรวจสอบว่า URL นั้นใช้งานได้หรือไม่
  Future<bool> checkUrl(String? url) async {
    try {
      if (url == null) return false;

      final response = await http.head(Uri.parse(url));
      return (response.statusCode >= 200 && response.statusCode < 300);
    } catch (e) {
      return false;
    }
  }

  // สร้างสตริงแบบสุ่ม
  String generateRandomString(int len) {
    var r = Random(); // สร้างตัวสร้างตัวเลขสุ่ม
    // ตัวอักษรและตัวเลขที่ใช้ในการสร้างสตริง
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    // สร้างสตริงโดยการสุ่มตัวอักษรจาก _chars
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  // ดึงตำแหน่งปัจจุบันของผู้ใช้
  Future<Result<Position, Failure>> getLocation() async {
    bool serviceEnabled; // ตรวจสอบว่าเปิดใช้งาน Location Service หรือไม่
    LocationPermission permission; // ตรวจสอบ Permission

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ถ้าไม่ได้เปิด Location Service
      return Error(Failure(message: 'No Permission'));
    }

    permission = await Geolocator.checkPermission(); // ตรวจสอบ Permission
    if (permission == LocationPermission.denied) {
      // ถ้ายังไม่มี Permission
      permission = await Geolocator.requestPermission(); // ขอ Permission
      if (permission == LocationPermission.denied) {
        // ถ้าผู้ใช้ปฏิเสธการขอ Permission
        return Error(Failure(message: 'No Permission'));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // ถ้าผู้ใช้ปฏิเสธการขอ Permission แบบถาวร
      return Error(Failure(message: 'No Permission'));
    }
    // ถ้ามี Permission ให้ดึงตำแหน่งปัจจุบัน
    return Success(await Geolocator.getCurrentPosition());
  }

  // แปลงวันที่ให้ ios
  DateTime parseTime(dynamic date) {
    return Platform.isIOS ? (date as Timestamp).toDate() : (date as DateTime);
  }
}
