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
import 'package:pharmacy_online/feature/admin/page/pharmacy_store_detail_screen.dart';
import 'package:pharmacy_online/feature/profile/enum/field_user_info_enum.dart';

class UserDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'UserDetailScreen';
  final PharmacyArgs args;

  const UserDetailScreen({
    super.key,
    required this.args,
  });

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends ConsumerState<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลผู้ใช้จาก PharmacyArgs
    final userInfo = widget.args.pharmacyItem;

    // ดึงข้อมูลที่ต้องการแสดงผลจาก PharmacyInfoResponse
    final profileImg = userInfo.profileImg;
    final fullname = userInfo.fullName;
    final phone = userInfo.phone;
    final licensePharmacy = userInfo.licensePharmacy;
    final licensePharmacyImg = userInfo.licensePharmacyImg;

    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'ข้อมูลเภสัชกร',
          style: AppStyle.txtHeader3,
        ),
      ),
      bodyBuilder: (context, constrianed) {
        return SingleChildScrollView(
          // ให้หน้าจอสามารถเลื่อนได้
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // แสดงรูปโปรไฟล์
                InteractiveViewer(
                  child: BaseImageView(
                    url: profileImg,
                    width: 350.w,
                    height: 350.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ช่องข้อมูลชื่อ-นามสกุล
                BaseTextField(
                  isReadOnly: true,
                  isShowLabelField: true,
                  initialValue: fullname,
                  label: "ชื่อ-นามสกุล",
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ช่องข้อมูลเบอร์โทร
                BaseTextField(
                  isReadOnly: true,
                  isShowLabelField: true,
                  initialValue: phone,
                  textInputType: TextInputType.phone,
                  label: "เบอร์โทรศัพท์",
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ช่องข้อมูลเลขที่ใบอนุญาตเภสัชกร
                BaseTextField(
                  fieldKey: FieldUserInfo.licensePharmacy,
                  initialValue: licensePharmacy,
                  isReadOnly: true,
                  isShowLabelField: true,
                  label: "เลขที่ใบอนุญาตเภสัชกร",
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'รูปใบอนุญาตเภสัชกร',
                  style: AppStyle.txtBody2,
                ),
                SizedBox(
                  height: 16.h,
                ),
                // แสดงรูปใบอนุญาตเภสัชกร
                InteractiveViewer(
                  child: BaseImageView(
                    url: licensePharmacyImg,
                    width: 300.w,
                    //height: 250.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ปุ่มที่เมื่อคลิกจะกลับไปที่หน้ารายละเอียดของร้านเภสัชกร
                BaseButton(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  text: 'ดูข้อมูลร้านขายยา',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
