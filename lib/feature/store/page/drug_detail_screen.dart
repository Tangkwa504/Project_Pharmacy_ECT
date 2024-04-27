import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/widget/quantity_widget.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';

// คลาส DrugDetailArgs ใช้สำหรับส่งข้อมูลยาไปยังหน้าจอ DrugDetailScreen
class DrugDetailArgs {
  final MedicineResponse medicineItem; // ข้อมูลยาที่จะแสดงในหน้าจอ
  final ChatWithPharmacyResponse?
      chatWithPharmacyItem; // ข้อมูลการแชทกับร้านขายยา (ถ้ามี)
  final bool isOnlyDetail;

  DrugDetailArgs({
    required this.medicineItem,
    this.chatWithPharmacyItem,
    this.isOnlyDetail = false,
  });
}

// คลาส DrugDetailScreen เป็นหน้าจอสำหรับแสดงรายละเอียดของยา
class DrugDetailScreen extends ConsumerStatefulWidget {
  static const routeName =
      'DrugDetailScreen'; // ชื่อเส้นทางสำหรับนำทางมายังหน้าจอนี้

  final DrugDetailArgs args; // ข้อมูลยาที่ได้รับการส่งมา

  const DrugDetailScreen({
    super.key,
    required this.args,
  });

  @override
  _DrugDetailScreenState createState() => _DrugDetailScreenState();
}

// State ของหน้าจอ DrugDetailScreen
class _DrugDetailScreenState extends BaseConsumerState<DrugDetailScreen> {
  int quantity = 1;
  double price = 0.0;

  @override
  Widget build(BuildContext context) {
    final args = widget.args; // ดึงข้อมูลยาจาก args
    final name = args.medicineItem.name; // ชื่อยา
    price = args.medicineItem.price ?? 0.0; // ราคายา (ถ้าไม่มีกำหนดเป็น 0.0)
    final image = args.medicineItem.medicineImg; // รูปภาพของยา
    final pharmacyInfo = ref.watch(profileControllerProvider
        .select((value) => value.pharmacyStore)); // อ่านข้อมูลร้านขายยา
    final size = args.medicineItem.size;
    final material = args.medicineItem.material;

    // ตรวจสอบว่าผู้ใช้เป็นแอดมินหรือไม่
    final isAdmin = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'รายละเอียดยา',
          style: AppStyle.txtHeader3,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 16.0,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bgColor: AppColor.themLineColor,
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            // รายละเอียดยา
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BaseImageView(
                  alignment: Alignment.center,
                  url: image,
                  fit: BoxFit.contain,
                  width: 300.w,
                  height: 300.h,
                  border:
                      Border.all(color: AppColor.themePrimaryColor, width: 1.2),
                  radius: BorderRadius.circular(15.0),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  children: [
                    Text(
                      'ชื่อยา ',
                      style: AppStyle.txtBody,
                    ),
                    Text(
                      '  $name',
                      style: AppStyle.txtBodylight,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  children: [
                    Text(
                      'ขนาดบรรจุ',
                      style: AppStyle.txtBody,
                    ),
                    Text(
                      '  $size',
                      style: AppStyle.txtBodylight,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                if (!isAdmin) ...[
                  Row(
                    children: [
                      Text(
                        'ราคา ',
                        style: AppStyle.txtBody,
                      ),
                      Text(
                        '$price',
                        style: AppStyle.txtBodylight,
                      ),
                      Text(
                        ' บาท',
                        style: AppStyle.txtBody,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                ],
                Text(
                  'ส่วนประกอบ',
                  style: AppStyle.txtBody,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  '     $material',
                  style: AppStyle.txtBody2,
                ),
                // SizedBox(
                //   height: 8.h,
                // ),
                // Text(
                //   '50 pcs',
                //   style: AppStyle.txtBody2
                //       .copyWith(color: AppColor.themeGrayLight),
                // ),
                SizedBox(
                  height: 16.h,
                ),
                // ตัวเลือกจำนวนยา
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!args.isOnlyDetail) ...[
                      QuantityWidget(
                        maximum: 100,
                        onUpdate: (val) {
                          setState(() {
                            quantity = val; // อัปเดตจำนวนยาเมื่อผู้ใช้แก้ไข
                          });
                        },
                      ),

                      // ... แสดงราคารวม ...
                      // Text(
                      //   'ราคา ${price * quantity} บาท',
                      //   style: AppStyle.txtBody,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'รวมทั้งหมด ',
                            style: AppStyle.txtBody,
                          ),
                          Text(
                            '${price * quantity}',
                            style: AppStyle.txtBodylight,
                          ),
                          Text(
                            ' บาท',
                            style: AppStyle.txtBody,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

                if (!args.isOnlyDetail) ...[
                  SizedBox(
                    height: 32.h,
                  ),
                  BaseButton(
                    // ฟังก์ชันที่ทำงานเมื่อกดปุ่ม
                    onTap: () async {
                      // เรียกใช้ฟังก์ชัน onAddToCart() ของ myCartControllerProvider
                      // เพื่อเพิ่มยาลงตะกร้า
                      final result = await ref
                          .read(myCartControllerProvider.notifier)
                          .onAddToCart(
                            // ข้อมูลร้านขายยา
                            '${args.chatWithPharmacyItem?.pharmacyId}',
                            '${args.chatWithPharmacyItem?.uid}',
                            //ข้อมูลยา
                            '${args.medicineItem.id}',
                            '$image',
                            price,
                            '$name',
                            quantity,
                            '${pharmacyInfo?.nameStore}', //ชื่อร้าน
                            '$size',
                            '$material',
                          );

                      // อัปเดตจำนวนยาในตะกร้า
                      ref
                          .read(myCartControllerProvider.notifier)
                          .setQuantity('${args.medicineItem.id}', quantity);

                      // แสดงข้อความแจ้งเตือนหากเพิ่มยาลงตะกร้าสำเร็จ
                      if (result) {
                        Fluttertoast.showToast(
                          msg: "เพิ่มลงตะกร้าสำเร็จ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    },
                    text: 'เพิ่มใส่ตะกร้า',
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
