import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/admin/controller/admin_controller.dart';
import 'package:pharmacy_online/feature/admin/widget/pharmacy_list_widget.dart';

class ApprovePharmacyScreen extends ConsumerStatefulWidget {
  const ApprovePharmacyScreen({super.key});

  @override
  _ApprovePharmacyScreenState createState() => _ApprovePharmacyScreenState();
}

class _ApprovePharmacyScreenState extends ConsumerState<ApprovePharmacyScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // สร้าง Timer ที่ทำงานทุก 200 มิลลิวินาที
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      // เรียกใช้ notifier จาก provider เพื่อดึงข้อมูลรายละเอียดร้านที่ยังไม่ได้รับการอนุมัติ
      await ref.read(adminControllerProvider.notifier).getPharmacyDetail();
    });
  }

  @override
  void dispose() {
    // ยกเลิก Timer เมื่อ Widget ถูก dispose เพื่อป้องกันการทำงานที่ไม่จำเป็น
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      // ใช้ BaseScaffold เป็น Widget หลักที่กำหนดโครงสร้างหน้าจอพื้นฐาน
      appBar: BaseAppBar(
        // กำหนด AppBar ด้านบนของหน้าจอ
        elevation: 0,
        hideBackButton: true,
        bgColor: AppColor.themeWhiteColor,
        title: Text(
          'คำขออนุมัติร้านขายยา',
          style: AppStyle.txtHeader3,
        ),
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        // ดึงข้อมูลรายการร้านที่ยังไม่ได้รับการอนุมัติ
        final pharmacyList = ref.watch(
          adminControllerProvider.select((value) => value.pharmacyInfoList),
        );

        // Widget สำหรับแสดงข้อมูลตามสถานะของ AsyncValue
        return AsyncValueWidget(
          value: pharmacyList,
          data: (_pharmacyList) {
            if (_pharmacyList == null) {
              return const SizedBox
                  .shrink(); // หากไม่มีข้อมูลให้แสดง Widget ขนาดเล็ก
            }
            return Padding(
              padding: const EdgeInsets.all(16).r,
              child: PharmacyListWidget(
                pharmacyList: _pharmacyList,
              ),
            );
          },
        );
      },
    );
  }
}
