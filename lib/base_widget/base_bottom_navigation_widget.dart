import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

// Widget สำหรับ Bottom Navigation Bar
class BottomNavigationWidget extends ConsumerStatefulWidget {
  // Callback function ที่จะเรียกเมื่อเปลี่ยนหน้า
  final Function(int currentPage) onChange;

// Constructor ของ Widget
  const BottomNavigationWidget({Key? key, required this.onChange})
      : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState
    extends BaseConsumerState<BottomNavigationWidget> {
  // ignore: prefer_final_fields กำหนดตัวแปรสำหรับเก็บ index ปัจจุบันของหน้า
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูล user info จาก Riverpod
    final hasUserInfo = ref
            .watch(profileControllerProvider.select((value) => value.userInfo))
            ?.uid !=
        null;

    // สร้าง Bottom Navigation Bar
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: AppColor.themePrimaryColor,
      unselectedLabelStyle:
          AppStyle.txtCaption.copyWith(color: AppColor.themePrimaryColor),
      selectedLabelStyle:
          AppStyle.txtCaption.copyWith(color: AppColor.themePrimaryColor),
      type: BottomNavigationBarType.fixed,
      items: [
        // Bottom Navigation Bar Item สำหรับหน้า Home
        BottomNavigationBarItem(
          activeIcon: Assets.icons.icHome.svg(
            width: 24.w,
            height: 24.h,
            color: AppColor.themePrimaryColor,
          ),
          icon: Assets.icons.icHome.svg(
            width: 24.w,
            height: 24.h,
          ),
          label: "หน้าหลัก",
        ),
        // Bottom Navigation Bar Item สำหรับหน้า Orders
        BottomNavigationBarItem(
          activeIcon: Assets.icons.icOrder.svg(
            width: 24.w,
            height: 24.h,
            color: AppColor.themePrimaryColor,
          ),
          icon: Assets.icons.icOrder.svg(
            width: 24.w,
            height: 24.h,
          ),
          label: "คำสั่งซื้อ",
        ),
        // Bottom Navigation Bar Item สำหรับหน้า Chat
        BottomNavigationBarItem(
          activeIcon: Assets.icons.icChat.svg(
            width: 24.w,
            height: 24.h,
            color: AppColor.themePrimaryColor,
          ),
          icon: Assets.icons.icChat.svg(
            width: 24.w,
            height: 24.h,
          ),
          label: "แชท",
        ),
        // Bottom Navigation Bar Item สำหรับหน้า Profile
        BottomNavigationBarItem(
          activeIcon: Assets.icons.icProfile.svg(
            width: 24.w,
            height: 24.h,
            color: AppColor.themePrimaryColor,
          ),
          icon: Assets.icons.icProfile.svg(
            width: 24.w,
            height: 24.h,
          ),
          label: "บัญชี",
        ),
      ],
      onTap: (value) {
        // ตรวจสอบว่ามีข้อมูล user info หรือไม่
        if (hasUserInfo) {
          // ถ้ามี user info ให้เปลี่ยน index ปัจจุบัน
          setState(() {
            _currentIndex = value;
          });
        } else {
          // ถ้าไม่มี user info และกำลังคลิกที่หน้า Orders หรือ Chat
          if (value == 1 || value == 2) {
            // ให้กลับไปที่หน้า Home
            setState(() {
              _currentIndex = 0;
            });
          } else {
            // ถ้าคลิกที่หน้าอื่น ๆ ให้เปลี่ยน index ปัจจุบัน
            setState(() {
              _currentIndex = value;
            });
          }
        }
        // เรียก callback function เพื่อแจ้งถึงการเปลี่ยนหน้า
        widget.onChange(value);
      },
    );
  }
}
