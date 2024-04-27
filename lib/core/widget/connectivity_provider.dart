import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provide DeviceInfoPlugin instance
/// สร้าง Provider ของ Connectivity เพื่อให้สามารถใช้งาน Connectivity ได้ทั่วทั้งแอป
final connectivityProvider = Provider<Connectivity>((ref) {
  // สร้างและคืนค่าอ็อบเจ็กต์ของ Connectivity
  return Connectivity();
});


//Provider connectivityProvider ในโค้ดด้านบนถูกใช้เพื่อให้สามารถเข้าถึงอ็อบเจ็กต์ 
//Connectivity ได้ทั่วทั้งแอป ซึ่งสามารถใช้เพื่อตรวจสอบสถานะการเชื่อมต่อของอุปกรณ์ได้ 
//เช่น การเชื่อมต่อผ่าน WiFi, 3G, 4G, 5G, หรือไม่มีการเชื่อมต่อเลย 
//โดยที่ Provider นี้จะถูกอ่านจาก ref (Reference) ที่ถูกสร้างขึ้นในตัว Consumer widget 
//หรือ ConsumerState widget ที่ต้องการใช้งาน Connectivity นี้