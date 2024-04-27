import 'package:flutter/material.dart';
import 'package:pharmacy_online/core/app_style.dart';

class RowContentWidget extends StatelessWidget {
  final bool isBold; // กำหนดค่าเริ่มต้นให้ header ไม่เป็นตัวหนา
  // รับค่า header และ content จากภายนอก
  final String header;
  final String content;

  // สร้าง widget Row แสดงเนื้อหาแบบแถว
  const RowContentWidget({
    super.key,
    this.isBold = false,
    required this.header,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, //ชิดซ้าย
      crossAxisAlignment: CrossAxisAlignment.start, //ชิดบน
      children: [
        Expanded(
          child: Text(
            header,
            style: AppStyle.txtBody2.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: AppStyle.txtBody2.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
