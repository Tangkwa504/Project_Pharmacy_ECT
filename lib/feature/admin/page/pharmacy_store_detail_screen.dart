import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/admin/page/user_detail_screen.dart';
// import 'package:pharmacy_online/feature/store/page/near_pharmacy_store_screen.dart';
// import 'package:pharmacy_online/feature/store/controller/store_controller.dart';

class PharmacyArgs {
  final PharmacyInfoResponse pharmacyItem;

  PharmacyArgs({required this.pharmacyItem});
}

class PharmacyDetailArgs {
  final PharmacyInfoResponse? pharmacyInfoResponse;

  PharmacyDetailArgs({
    required this.pharmacyInfoResponse,
  });
}

class PharmacyStoreDetaillScreen extends ConsumerStatefulWidget {
  static const routeName = 'PharmacyStoreDetaillScreen';
  final PharmacyArgs args;

  const PharmacyStoreDetaillScreen({
    super.key,
    required this.args,
  });

  @override
  _PharmacyStoreDetaillScreenState createState() =>
      _PharmacyStoreDetaillScreenState();
}

class _PharmacyStoreDetaillScreenState
    extends ConsumerState<PharmacyStoreDetaillScreen> {
  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลร้านเภสัชกรที่ถูกส่งมาจากหน้าจอก่อนหน้า
    final pharmacyStoreInfo = widget.args.pharmacyItem;

    // ดึงข้อมูลที่ต้องการแสดงผลจาก PharmacyInfoResponse
    final pharmacyStoreImg = pharmacyStoreInfo.storeImg;
    final licensePharmacyStore = pharmacyStoreInfo.licenseStoreImg;
    final nameStore = pharmacyStoreInfo.nameStore;
    final phoneStore = pharmacyStoreInfo.phoneStore;
    final address = pharmacyStoreInfo.addressStore;
    final timeClosing = pharmacyStoreInfo.timeClosing;
    final timeOpening = pharmacyStoreInfo.timeOpening;
    final licenseStore = pharmacyStoreInfo.licenseStore;

    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'ข้อมูลร้านขายยา',
          style: AppStyle.txtHeader3,
        ),
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          // ให้หน้าจอสามารถเลื่อนได้
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BaseImageView(
                  url: pharmacyStoreImg,
                  width: 350.w,
                  height: 250.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ช่องข้อมูลชื่อร้าน
                BaseTextField(
                  isReadOnly: true,
                  isShowLabelField: true,
                  initialValue: nameStore,
                  label: "ชื่อร้าน",
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ช่องข้อมูลที่อยู่
                BaseTextField(
                  label: "ที่อยู่",
                  initialValue: address,
                  isReadOnly: true,
                  isShowLabelField: true,
                ),

                SizedBox(
                  height: 16.h,
                ),
                // ช่องข้อมูลเบอร์โทร
                BaseTextField(
                  initialValue: phoneStore,
                  isReadOnly: true,
                  isShowLabelField: true,
                  textInputType: TextInputType.phone,
                  label: "เบอร์โทรศัพท์",
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ช่องข้อมูลเวลาเปิด
                BaseTextField(
                  label: "เวลาเปิดทำการ",
                  isReadOnly: true,
                  isShowLabelField: true,
                  initialValue: timeOpening,
                  textInputType: TextInputType.datetime,
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ช่องข้อมูลเวลาปิด
                BaseTextField(
                  isReadOnly: true,
                  isShowLabelField: true,
                  label: "เวลาปิดทำการ",
                  initialValue: timeClosing,
                  textInputType: TextInputType.datetime,
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ช่องข้อมูลเลขที่ใบอนุญาตร้าน
                BaseTextField(
                  isReadOnly: true,
                  isShowLabelField: true,
                  label: "เลขที่ใบอนุญาตร้าน",
                  initialValue: licenseStore,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'รูปใบอนุญาตร้านขายยา',
                  style: AppStyle.txtBody2,
                ),
                SizedBox(
                  height: 16.h,
                ),
                // แสดงรูปใบอนุญาตร้าน
                InteractiveViewer(
                  child: BaseImageView(
                    url: licensePharmacyStore,
                    width: 350.w,
                    //height: 250.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ปุ่มที่เมื่อคลิกจะนำไปยังหน้ารายละเอียดของเภสัชกร
                BaseButton(
                  onTap: () async {
                    Navigator.of(context).pushNamed(
                      UserDetailScreen.routeName,
                      arguments: PharmacyArgs(pharmacyItem: pharmacyStoreInfo),
                    );
                  },
                  text: 'ดูข้อมูลเภสัชกร',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
