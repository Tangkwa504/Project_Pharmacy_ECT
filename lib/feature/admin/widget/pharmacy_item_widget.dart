import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/admin/controller/admin_controller.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/admin/page/pharmacy_store_detail_screen.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';

class PharmacyItemWidget extends ConsumerWidget {
  final PharmacyInfoResponse pharmacyItem;

  const PharmacyItemWidget({
    super.key,
    required this.pharmacyItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                PharmacyStoreDetaillScreen.routeName,
                arguments: PharmacyArgs(
                  pharmacyItem: pharmacyItem,
                ),
              );
            },
            child: Row(
              children: [
                BaseImageView(
                  url: '${pharmacyItem.storeImg}',
                  width: 80.w,
                  height: 70.h,
                  fit: BoxFit.cover,
                  radius: const BorderRadius.all(
                    Radius.circular(150 / 2),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'ร้าน ${pharmacyItem.nameStore}',
                        style: AppStyle.txtBody2,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        statusText('${pharmacyItem.status}'),
                        style: AppStyle.txtBody2.copyWith(
                          color: statusTextColor('${pharmacyItem.status}'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BaseButton(
              width: 80.w,
              onTap: () async {
                // อัปเดตข้อมูลร้านใน Firebase Cloud Firestore เพื่ออนุมัติ
                ref
                    .read(adminControllerProvider.notifier)
                    .updatePharmacyDetail(true, '${pharmacyItem.uid}', false);

                // ดึงข้อมูลร้านอีกครั้งหลังจากอัปเดต
                await ref
                    .read(adminControllerProvider.notifier)
                    .getPharmacyDetail();

                // ส่ง Notification ถึงผู้ใช้ว่าร้านของเขาได้รับการอนุมัติ
                await ref
                    .read(homeControllerProvider.notifier)
                    .onPostNotification(
                      'ร้านขายยาได้รับการอนุมัติแล้ว',
                      OrderStatus.completed.name,
                      '${pharmacyItem.uid}',
                    );
              },
              text: 'อนุมัติ',
            ),
            SizedBox(
              height: 8.h,
            ),
            BaseButton(
              width: 80.w,
              buttonType: ButtonType.primary,
              color: AppColor.warningColor,
              onTap: () async {
                // อัปเดตข้อมูลร้านใน Firebase Cloud Firestore เพื่อแจ้งเตือน
                ref
                    .read(adminControllerProvider.notifier)
                    .updatePharmacyDetail(false, '${pharmacyItem.uid}', true);

                // ดึงข้อมูลร้านอีกครั้งหลังจากอัปเดต
                await ref
                    .read(adminControllerProvider.notifier)
                    .getPharmacyDetail();

                // ส่ง Notification ถึงผู้ใช้ว่าร้านของเขาข้อมูลไม่ถูกต้อง
                await ref
                    .read(homeControllerProvider.notifier)
                    .onPostNotification(
                      'มีข้อมูลไม่ถูกต้อง กรุณาแก้ไขข้อมูลหรือติดต่อ admin@gmail.com',
                      'warningChat',
                      '${pharmacyItem.uid}',
                    );
              },
              text: 'แจ้งเตือน',
            ),
            SizedBox(
              height: 8.h,
            ),
            BaseButton(
              width: 80.w,
              buttonType: ButtonType.danger,
              onTap: () async {
                // อัปเดตข้อมูลร้านใน Firebase Cloud Firestore เพื่อไม่อนุมัติและแบน
                ref
                    .read(adminControllerProvider.notifier)
                    .updatePharmacyDetail(false, '${pharmacyItem.uid}', false);

                // ดึงข้อมูลร้านอีกครั้งหลังจากอัปเดต
                await ref
                    .read(adminControllerProvider.notifier)
                    .getPharmacyDetail();

                // ส่ง Notification ถึงผู้ใช้ว่าร้านของเขาไม่ได้รับการอนุมัติ
                // await ref
                //     .read(homeControllerProvider.notifier)
                //     .onPostNotification(
                //       'ข้อมูลไม่ถูกต้อง กรุณาแก้ไขข้อมูล',
                //       'cancel',
                //       '${pharmacyItem.uid}',
                //     );
              },
              text: 'แบน',
            ),
          ],
        )
      ],
    );
  }

  // กำหนดข้อความสถานะตามสถานะที่ได้รับ
  String statusText(String status) {
    if (status == 'waiting') {
      return 'รออนุมัติ';
    } else if (status == 'waitingEdit') {
      return 'รอการแก้ไข';
    } else if (status == 'approve') {
      return 'ร้านได้รับการอนุมัติแล้ว';
    } else {
      return 'แบนชั่วคราว';
    }
  }

  // กำหนดสีข้อความสถานะตามสถานะที่ได้รับ
  Color statusTextColor(String status) {
    if (status == 'waiting' || status == 'waitingEdit') {
      return AppColor.themeYellowColor;
    } else if (status == 'approve') {
      return AppColor.themeSuccess;
    } else {
      return AppColor.errorColor;
    }
  }
}
