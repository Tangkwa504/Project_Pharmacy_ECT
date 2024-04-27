import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/error/failure.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  // รับ AsyncValue<T> เพื่อจัดการกับสถานะต่าง ๆ ของข้อมูล
  final AsyncValue<T> value;
  // ฟังก์ชันที่รับค่า T และสร้าง Widget จากข้อมูลนั้น
  final Widget Function(T) data;
  // กำหนดให้แสดง Loading Widget หรือไม่
  final bool showLoading;
  // กำหนดให้แสดง Error Widget หรือไม่
  final bool showError;
  // Widget ที่จะแสดงเมื่อกำลังโหลดข้อมูล
  final Widget? loadingWidget;

  // Constructor ของ Widget
  const AsyncValueWidget({
    Key? key,
    required this.value,
    required this.data,
    this.showLoading = true,
    this.showError = true,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // กำหนด Loading Widget ให้เป็น CircularProgressIndicator.adaptive() ถ้าไม่ได้ระบุ
    final _loadingWidget = loadingWidget ??
        const Center(
          child: CircularProgressIndicator.adaptive(),
        );

    // ใช้ value.when เพื่อตรวจสอบสถานะของ AsyncValue<T> และสร้าง Widget ตามเงื่อนไข
    return value.when(
      // กรณีข้อมูลถูกโหลดเสร็จสิ้น
      data: data,
      // กรณีเกิดข้อผิดพลาด
      error: (error, stackTrace) {
        final failure = error as Failure;
        // สร้าง Widget แสดงข้อผิดพลาดถ้า showError เป็น true
        return showError
            ? Center(
                child: Text(failure.message),
              )
            : const SizedBox
                .shrink(); // ถ้า showError เป็น false ให้แสดง SizedBox.shrink()
      },
      // กรณีกำลังโหลดข้อมูล
      loading: () {
        // สร้าง Loading Widget ถ้า showLoading เป็น true
        return showLoading
            ? _loadingWidget
            : const SizedBox
                .shrink(); // ถ้า showLoading เป็น false ให้แสดง SizedBox.shrink()
      },
    );
  }
}
