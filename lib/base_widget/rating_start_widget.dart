import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingStartWidget extends StatelessWidget {
  final Function(double) onRatingUpdate;
  final bool allowHalfRating;
  final bool isReadable;
  final double initialRating;
  final double? itemSize;

  const RatingStartWidget({
    super.key,
    required this.onRatingUpdate,
    this.allowHalfRating = true,
    this.isReadable = false,
    this.initialRating = 0,
    this.itemSize,
  });

  @override
  Widget build(BuildContext context) {
    double roundedRating =
        initialRating.floor().toDouble(); // ปัดคะแนนรีวิวลงเป็นจำนวนเต็ม
    if (initialRating - roundedRating >= 0.5) {
      // ถ้ามีคะแนนทศนิยมมากกว่าหรือเท่ากับ 0.5 ให้เพิ่มคะแนนครึ่งดาว
      roundedRating += 0.5;
    }
    return RatingBar.builder(
      initialRating: roundedRating, //initialRating, // ตั้งค่าคะแนนเริ่มต้น
      minRating: 1, // ตั้งค่าคะแนนต่ำสุด
      ignoreGestures:
          isReadable, // กำหนดว่าให้สามารถแสดงคะแนนทศนิยมครึ่งหรือไม่
      direction: Axis.horizontal, // กำหนดทิศทางของการแสดงดาว (แนวนอน)
      allowHalfRating:
          allowHalfRating, // กำหนดให้สามารถให้คะแนนทศนิยมครึ่งได้หรือไม่
      itemCount: 5, // จำนวนดาวทั้งหมด
      itemSize: itemSize ?? 40, // กำหนดขนาดของแต่ละดาว
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0)
          .w, // กำหนดระยะห่างระหว่างแต่ละดาว
      // กำหนดรูปแบบของแต่ละดาว
      itemBuilder: (context, _) => const Icon(
        Icons.star, //ไอค่อนดาว
        color: Colors.amber, //สีดาว
      ),
      // เมื่อมีการแปลงคะแนน
      onRatingUpdate: onRatingUpdate,
    );
  }
}
