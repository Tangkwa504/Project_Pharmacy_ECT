import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

class MenuButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Widget imgWidget;
  final String label;
  final bool isSecondBtn;

  const MenuButtonWidget({
    super.key,
    required this.onTap,
    required this.imgWidget,
    required this.label,
    this.isSecondBtn = false,
  });

  @override
  Widget build(BuildContext context) { //การกำหนดรูปแบบปุ่มหน้า menu
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 152.w,
        height: 152.h,
        padding: const EdgeInsets.all(16).r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSecondBtn
              ? AppColor.themeGrayLight
              : AppColor.themePrimaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imgWidget,
            SizedBox(
              height: 8.h,
            ),
            Text(
              label,
              style: AppStyle.txtHeader3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
