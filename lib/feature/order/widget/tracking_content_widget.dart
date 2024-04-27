import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

// คลาสสำหรับสร้าง widget แสดงเนื้อหาการติดตาม
class TrackingContentWidget extends StatelessWidget {
  // ตัวแปรเก็บข้อมูลต่าง ๆ ที่ใช้ใน widget
  final String number;
  final String title;
  final String? content;
  final double? contentHeight;
  final bool hasBtn;
  final bool hasSecondBtn;
  final bool isSuccess;
  final bool isSecondBtn;
  final String btnTxt;
  final VoidCallback? onTap;
  final VoidCallback? onTapSecond;
  final String btnTxtSecond;

  // คอนสตรักเตอร์สำหรับกำหนดค่าเริ่มต้นของตัวแปร
  const TrackingContentWidget({
    super.key,
    required this.number,
    required this.title,
    this.content,
    this.contentHeight,
    this.hasBtn = true,
    this.hasSecondBtn = false,
    this.isSuccess = false,
    this.isSecondBtn = true,
    this.btnTxt = '',
    this.btnTxtSecond = '',
    this.onTap,
    this.onTapSecond,
  });

  // เมธอดสำหรับสร้างและแสดง widget บนหน้าจอ
  @override
  Widget build(BuildContext context) {
    // สร้าง Column เพื่อจัดเรียงเนื้อหา
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // แถวแสดงหมายเลขและชื่อหัวข้อ
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ตรวจสอบสถานะการทำงานสำเร็จหรือไม่
            isSuccess
                ? Assets.icons.icSuccessStatus.svg()
                : Container(
                    // กำหนดขนาดและสีของส่วนตัวเลข
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                            .r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150 / 2),
                      color: AppColor.themeGrayLight,
                    ),
                    child: Text(
                      number,
                      style: AppStyle.txtCaption
                          .copyWith(color: AppColor.themeWhiteColor),
                    ),
                  ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              title,
              style: AppStyle.txtBody,
            ),
          ],
        ),
        // ส่วนแสดงเนื้อหาการติดตาม
        Container(
          margin: const EdgeInsets.fromLTRB(
            16.0,
            8.0,
            0,
            8.0,
          ).r,
          // กำหนดสีและขอบของ container
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppColor.themeGrayLight,
                width: 1.0,
              ),
            ),
          ),
          height: contentHeight,
          child: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Column(
              crossAxisAlignment:
                  hasBtn ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              mainAxisAlignment:
                  hasBtn ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                // ตรวจสอบว่ามีข้อมูลเนื้อหาหรือไม่
                if (content != null) ...[
                  Row(
                    // เส้นแสดงที่ใช้แบ่งเนื้อหา
                    children: [
                      Container(
                        height: 1.h,
                        width: 20.w,
                        color: AppColor.themeGrayLight,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        '$content',
                        style: AppStyle.txtCaption
                            .copyWith(color: AppColor.themeGrayLight),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
                // แถวปุ่ม
                Row(
                  children: [
                    if (hasBtn) ...[
                      // ปุ่มหลัก
                      BaseButton(
                        width: 100.w,
                        onTap: onTap ?? () {},
                        buttonType: isSecondBtn
                            ? ButtonType.secondary
                            : ButtonType.primary,
                        txtColor: AppColor.themeGrayLight,
                        text: btnTxt,
                      ),
                    ],
                    if (hasSecondBtn) ...[
                      SizedBox(
                        width: 8.w,
                      ),
                      // ปุ่มรอง
                      BaseButton(
                        width: 100.w,
                        onTap: onTapSecond ?? () {},
                        buttonType: ButtonType.primary,
                        txtColor: AppColor.themeGrayLight,
                        text: btnTxtSecond,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
