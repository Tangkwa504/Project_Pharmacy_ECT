import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class ProfileMenuWidget extends StatelessWidget {
  // รับข้อมูลไอคอนหน้าปก ข้อความ และฟังก์ชันสำหรับเรียกใช้งานเมื่อแตะมาแสดงผล
  final VoidCallback onTap;
  final Widget prefixIcon;
  final String label;

  const ProfileMenuWidget({
    super.key,
    required this.onTap,
    required this.prefixIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          prefixIcon,
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Text(
              label,
              style: AppStyle.txtBody2,
            ),
          ),
          Assets.icons.icRight.svg(),
        ],
      ),
    );
  }
}
