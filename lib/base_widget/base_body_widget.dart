import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseBodyWidget extends StatelessWidget {
  final Widget? header; // Widget ที่จะแสดงเป็น header
  final Widget body; // Widget ที่จะแสดงเป็น body
  final Widget bottom; // Widget ที่จะแสดงด้านล่าง

// Constructor ของ Widget
  const BaseBodyWidget({
    super.key,
    this.header,
    required this.body,
    required this.bottom,
  });

  // ตัวฟังก์ชัน build ที่ใช้สร้าง UI ของ Widget
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Column เพื่อวาง Widget ทั้งหมด
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ถ้ามี header ให้แสดง
            if (header != null) ...[
              header!,
            ],
            // Expanded เพื่อให้ body ยังคงต้องทั้งความสูงของหน้าจอ
            Expanded(
              child: Padding(
                // Padding สำหรับ body
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 8.0,
                  bottom: kBottomNavigationBarHeight,
                ).r,
                child: body,
              ),
            ),
          ],
        ),
        // Positioned เพื่อวาง bottom widget ด้านล่างของหน้าจอ
        Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 8,
          child: Padding(
            // Padding สำหรับ bottom widget
            padding: const EdgeInsets.symmetric(horizontal: 16).w,
            child: bottom,
          ),
        ),
      ],
    );
  }
}
