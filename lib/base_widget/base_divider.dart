import 'package:flutter/material.dart';
import 'package:pharmacy_online/core/app_color.dart';

class BaseDivider extends StatelessWidget {
  final double top, bottom; // กำหนดระยะห่างด้านบนและด้านล่างของ Divider
  final Color? bgColor; // กำหนดสีพื้นหลังของ Divider

// Constructor ของ BaseDivider
  const BaseDivider({
    super.key,
    this.top = 4,
    this.bottom = 4,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    // สร้าง Container ที่เป็น Divider
    return Container(
      height: 1, // กำหนดความสูงของ Divider เป็น 1 pixel
      width: MediaQuery.of(context)
          .size
          .width, // กำหนดความกว้างของ Divider ให้เต็มจอ
      alignment: Alignment.center, // กำหนดให้ Divider อยู่ตรงกลาง
      margin: EdgeInsets.only(
          top: top,
          bottom: bottom), // กำหนดระยะห่างด้านบนและด้านล่างของ Divider
      // กำหนดสไตล์และสีพื้นหลังของ Divider
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColor ?? AppColor.themGraySoftLight,
      ),
    );
  }
}
