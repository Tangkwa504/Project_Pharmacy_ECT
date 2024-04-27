import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/utils/image_picker/image_picker_provider.dart';
import 'package:pharmacy_online/utils/image_picker/model/image_picker_config_request.dart';
import 'package:pharmacy_online/utils/util/base_permission_handler.dart';

// หน้าจอแก้ไข QR Code
class EditQRCodeScreen extends ConsumerStatefulWidget {
  static const routeName = 'EditQRCodeScreen';

  const EditQRCodeScreen({super.key});

  @override
  _EditQRCodeScreenState createState() => _EditQRCodeScreenState();
}

class _EditQRCodeScreenState extends BaseConsumerState<EditQRCodeScreen> {
  XFile? qrCodeFile; //ตัวแปรสำหรับเก็บไฟล์ QR Code
  bool visible = true; //ซ่อนปุ่ม

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลร้านเภสัชกรจาก riverpod
    final pharmacyStore = ref.watch(
      profileControllerProvider.select((value) => value.pharmacyStore),
    );

    // ดึง URL ของรูป QR Code จากข้อมูลร้านเภสัชกร
    final qrCodeImg = pharmacyStore?.qrCodeImg;

    // สร้างหน้าจอด้วย BaseScaffold
    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'แก้ไข QR Code',
          style: AppStyle.txtHeader3,
        ),
      ),
      // สร้าง Body ด้วย Container เพื่อจัดวาง Element ต่าง ๆ
      bodyBuilder: (context, constrained) {
        return Container(
          padding: const EdgeInsets.all(16).r,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              // Container สำหรับแสดงรูป QR Code
              Container(
                padding: const EdgeInsets.all(8).r,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.themePrimaryColor,
                    width: 1, // red as border color
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      16,
                    ),
                  ),
                ),
                child: BaseImageView(
                  url: qrCodeFile != null ? null : qrCodeImg,
                  file: qrCodeFile != null ? File(qrCodeFile!.path) : null,
                  width: 350.w,
                  height: 350.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              // ปุ่มสำหรับอัปโหลดรูป QR Code
              BaseButton(
                onTap: () async {
                  // ขอสิทธิ์การเข้าถึงพื้นที่จัดเก็บและการเข้าถึงรูปภาพ
                  final isGrant = await ref
                      .read(basePermissionHandlerProvider)
                      .requestStoragePermission();
                  final isGrant31 = await ref
                      .read(basePermissionHandlerProvider)
                      .requestPhotosPermission();
                  if (isGrant || isGrant31) {
                    // ให้ผู้ใช้เลือกรูปจากแกลเลอรี
                    final result =
                        await ref.read(imagePickerUtilsProvider).getImage(
                              const ImagePickerConfigRequest(
                                source: ImageSource.gallery,
                                maxHeight: 1920,
                                maxWidth: 2560,
                                imageQuality: 30,
                                //isMaximum2MB: true,
                              ),
                            );

                    // ตรวจสอบผลลัพธ์การเลือกรูป
                    result.when(
                      (success) {
                        setState(() {
                          qrCodeFile = success[0];
                        });
                      },
                      // กรณีที่เกิดข้อผิดพลาด
                      (error) async {
                        await showBaseDialog(
                          context: context,
                          builder: (ctx) {
                            return BaseDialog(
                              message: error.message,
                            );
                          },
                        );
                      },
                    );
                  }
                },
                text: 'อัปโหลดรูป',
                buttonType: ButtonType.secondary,
              ),
              SizedBox(
                height: 16.h,
              ),
              // ปุ่มสำหรับยืนยันการแก้ไขข้อมูล
              Visibility(
                visible: qrCodeFile != null && visible,
                child: BaseButton(
                  onTap: () async {
                    // เรียกใช้เมธอดใน ProfileController เพื่อทำการเปลี่ยนแปลงรูป QR Code
                    final result = await ref
                        .read(profileControllerProvider.notifier)
                        .onChangeQRCode(qrCodeFile);

                    // แสดงปุ่มยืนยัน
                    setState(() {
                      visible = true;
                    });

                    // ตรวจสอบผลลัพธ์การแก้ไข
                    if (result) {
                      // โหลดข้อมูลร้านเภสัชกรใหม่
                      await ref
                          .read(
                            profileControllerProvider.notifier,
                          )
                          .onGetPharmacyStore();

                      // แสดง Dialog เมื่อการแก้ไขสำเร็จ
                      await showBaseDialog(
                        context: context,
                        builder: (ctx) {
                          return BaseDialog(
                            message: 'แก้ไขสำเร็จ',
                          );
                        },
                      );
                      setState(() {
                        visible = false; //ซ่อนปุ่มยืนยัน
                      });
                    } else {
                      // แสดง Dialog เมื่อการแก้ไขไม่สำเร็จ
                      await showBaseDialog(
                        context: context,
                        builder: (ctx) {
                          return BaseDialog(
                            message: 'แก้ไขไม่สำเร็จ',
                          );
                        },
                      );
                    }
                  },
                  text: 'ยืนยัน',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
