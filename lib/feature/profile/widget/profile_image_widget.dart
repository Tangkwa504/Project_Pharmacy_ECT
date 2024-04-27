import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

class ProfileImageWidget extends ConsumerWidget {
  // รับข้อมูลรูปภาพ URL และชื่อผู้ใช้มาแสดงผล
  final String imageUrl;
  final String name;

  const ProfileImageWidget({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, //ตรงกลางแนวตั้ง
      mainAxisAlignment: MainAxisAlignment.center, //ตรงกลางแนวนอน
      children: [
        // แสดงรูปภาพโปรไฟล์
        BaseImageView(
          radius: BorderRadius.circular(30),
          url: imageUrl,
          width: 80.w, // กำหนดความกว้างตามขนาดหน้าจอโดยใช้ ScreenUtil
          height: 124.h, // กำหนดความสูงตามขนาดหน้าจอโดยใช้ ScreenUtil
          fit: BoxFit.cover, // ปรับขนาดรูปภาพให้เต็มพื้นที่
        ),
        SizedBox(
          height: 16.h,
        ),
        // แสดงชื่อผู้ใช้
        Text(
          name,
          style: AppStyle.txtBody2.copyWith(
            color: AppColor.themePrimaryColor,
          ),
        ),
      ],
    );
  }
}
