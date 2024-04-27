import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/admin/controller/admin_controller.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class AdminBottomNavigationWidget extends ConsumerStatefulWidget {
  final Function(int currentPage) onChange;

  const AdminBottomNavigationWidget({Key? key, required this.onChange})
      : super(key: key);

  @override
  _AdminBottomNavigationWidgetState createState() =>
      _AdminBottomNavigationWidgetState();
}

class _AdminBottomNavigationWidgetState
    extends BaseConsumerState<AdminBottomNavigationWidget> {
  // ignore: prefer_final_fields
  int _currentIndex = 0;

  @override
  void initState() {
    // เมื่อ widget ถูกสร้างใหม่
    // ใช้ addPostFrameCallback เพื่อให้ทำงานหลังจาก frame แรกสร้างเสร็จ
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // เรียกใช้เมธอด onGetCentralMedicineWarehouse จาก Store Controller
      await ref
          .read(storeControllerProvider.notifier)
          .onGetCentralMedicineWarehouse();
      // เรียกใช้เมธอด getPharmacyDetail จาก Admin Controller
      await ref.read(adminControllerProvider.notifier).getPharmacyDetail();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: AppColor.themePrimaryColor,
      unselectedLabelStyle:
          AppStyle.txtCaption.copyWith(color: AppColor.themePrimaryColor),
      selectedLabelStyle:
          AppStyle.txtCaption.copyWith(color: AppColor.themePrimaryColor),
      type: BottomNavigationBarType.fixed,
      items: [
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
        BottomNavigationBarItem(
          activeIcon: Assets.icons.icMedicine.svg(
            width: 24.w,
            height: 24.h,
            color: AppColor.themePrimaryColor,
          ),
          icon: Assets.icons.icMedicine.svg(
            width: 24.w,
            height: 24.h,
          ),
          label: "คลังยา",
        ),
        BottomNavigationBarItem(
          activeIcon: Assets.icons.icLocationPin.svg(
            width: 24.w,
            height: 24.h,
            color: AppColor.themePrimaryColor,
          ),
          icon: Assets.icons.icLocationPin.svg(
            width: 24.w,
            height: 24.h,
          ),
          label: "แผนที่",
        ),
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
        // เมื่อมีการเลือก BottomNavigationBarItem
        setState(() {
          _currentIndex = value;
        });
        // เรียกเมธอด onChange ที่ถูกส่งเข้ามาผ่าน constructor
        widget.onChange(value);
      },
    );
  }
}
