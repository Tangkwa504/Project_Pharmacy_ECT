import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart' as permission_lib;
import 'package:pharmacy_online/core/application/custom_platform.dart';

final basePermissionHandlerProvider =
    Provider((ref) => BasePermissionHandler());

class BasePermissionHandler {
  // เมธอดส่วนตัวสำหรับขอ Permission
  Future<bool> _requestPermission(permission_lib.Permission permission) async {
    try {
      // ตรวจสอบสถานะ Permission ปัจจุบัน
      final _permissionStatus = await permission.status;
      if (_permissionStatus.isGranted) {
        // ถ้าได้รับ Permission แล้ว ให้คืนค่า true
        return true;
      } else if (!_permissionStatus.isPermanentlyDenied) {
        // ถ้ายังไม่ได้ได้รับ Permission และยังไม่ถูกปฏิเสธถาวร
        // ให้ขอ Permission
        final newStatus = await permission.request();
        if (newStatus.isGranted) {
          // ถ้าได้รับ Permission แล้ว ให้คืนค่า true
          return true;
        }
      }

      // ถ้าไม่ได้รับ Permission ให้คืนค่า false
      return false;
    } catch (e) {
      // ถ้าเกิดข้อผิดพลาด ให้คืนค่า false
      return false;
    }
  }

  // เมธอดสำหรับขอ Permission ของกล้อง
  Future<bool> requestCameraPermission() async {
    return _requestPermission(permission_lib.Permission.camera);
  }

  // เมธอดสำหรับขอ Permission ของรูปภาพในคลังภาพ
  Future<bool> requestPhotosPermission() async {
    return _requestPermission(permission_lib.Permission.photos);
  }

  // เมธอดสำหรับขอ Permission ในการบันทึกภาพ
  // บน Android จะใช้ Permission.storage
  // บน iOS จะใช้ Permission.photosAddOnly
  Future<bool> requestSaveImagePermission() async {
    return CustomPlatform.isAndroid
        ? _requestPermission(permission_lib.Permission.storage)
        : _requestPermission(permission_lib.Permission.photosAddOnly);
  }

  // เมธอดสำหรับขอ Permission ของพื้นที่จัดเก็บ
  Future<bool> requestStoragePermission() async {
    return _requestPermission(permission_lib.Permission.storage);
  }

  // เมธอดสำหรับเปิดหน้าการตั้งค่า Permission ของแอปพลิเคชัน
  void openAppSettings() {
    permission_lib.openAppSettings();
  }
}
