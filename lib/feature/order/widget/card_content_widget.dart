import 'package:flutter/material.dart';
import 'package:pharmacy_online/core/app_color.dart';

class CardContentWidget extends StatelessWidget {
  // ประกาศตัวแปร content เก็บข้อมูล Widget ที่ต้องการแสดงใน Card
  final Widget content;

  // สร้าง constructor สำหรับรับค่าตัวแปร content จากภายนอก
  const CardContentWidget({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.themeWhiteColor,
      ),
      width: MediaQuery.of(context).size.width,
      child: content,
    );
  }
}
