import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider สำหรับการจัดการสถานะการโหลดของแอปพลิเคชัน
final loaderControllerProvider =
    StateNotifierProvider<LoaderController, bool>((ref) {
  return LoaderController();
});

// คลาส Controller ที่รับผิดชอบในการจัดการสถานะการโหลด
class LoaderController extends StateNotifier<bool> {
  // คอนสตรักเตอร์สำหรับกำหนดค่าเริ่มต้นของ Controller พร้อมกับสถานะการโหลด
  LoaderController({bool isLoading = false}) : super(isLoading) {
    state = isLoading;
  }

  // เมธอดที่ใช้ในการเปลี่ยนสถานะการโหลดเป็น true
  void onLoad() {
    state = true;
  }

  // เมธอดที่ใช้ในการเปลี่ยนสถานะการโหลดเป็น false
  void onDismissLoad() {
    state = false;
  }
}
