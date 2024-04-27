import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/profile/enum/field_user_info_enum.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

//import 'package:fluttertoast/fluttertoast.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static const routeName = 'EditProfileScreen';

  const EditProfileScreen({
    super.key,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  XFile? licenseFile, imgProfile;
  bool isRequiredProfile = false, isRequiredLicensePharmacy = false;
  TextEditingController addressController = TextEditingController();
  final formKey = GlobalKey<BaseFormState>();

  bool isValidated = false; //ตรวจสอบ
  bool isTextFieldReadOnly = true; // ตรวจสอบตำแหน่งที่อยู่
  bool isEdited = false; //ตรวจสอบการแก้ไข

  @override
  void initState() {
    super.initState();
    // เมื่อโหลด Widget เสร็จ อ่านข้อมูลผู้ใช้และข้อมูลร้าน และกำหนดค่าให้กับ Textfield ที่เกี่ยวข้อง
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final userInfo = ref.watch(
        profileControllerProvider.select((value) => value.userInfo),
      );

      final pharmacyStoreInfo = ref.watch(
        profileControllerProvider.select((value) => value.pharmacyStore),
      );
      addressController.text =
          '${userInfo?.address ?? pharmacyStoreInfo?.address}';
    });
  }

  @override
  void dispose() {
    super.dispose();
    // คืนทรัพยากรเมื่อ Widget ถูกทำลาย
    addressController.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลจาก Provider
    final isPharmacy = ref.watch(
      profileControllerProvider.select((value) => value.isPharmacy),
    );
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );

    final pharmacyStoreInfo = ref.watch(
      profileControllerProvider.select((value) => value.pharmacyStore),
    );

    var profileImg = userInfo?.profileImg;
    var fullname = userInfo?.fullName;
    var phone = userInfo?.phone;
    var licensePharmacy = pharmacyStoreInfo?.licensePharmacy;
    var licensePharmacyImg = pharmacyStoreInfo?.licensePharmacyImg;
    var allergy = userInfo?.allergy;

    // สร้างหน้าจอด้วย BaseScaffold
    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'แก้ไขข้อมูลส่วนตัว',
          style: AppStyle.txtHeader3,
        ),
      ),
      // สร้าง Body ด้วย SingleChildScrollView เพื่อให้สามารถเลื่อนหน้าจอได้
      bodyBuilder: (context, constrianed) {
        return SingleChildScrollView(
          child: BaseForm(
            key: formKey,
            onChanged: ref.read(profileControllerProvider.notifier).onChanged,
            child: Padding(
              padding: const EdgeInsets.all(16).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Widget สำหรับอัปโหลดรูปโปรไฟล์
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
                    child: BaseUploadImageButton(
                      imgPreview: BaseImageView(
                        url: imgProfile != null ? null : profileImg,
                        file:
                            imgProfile != null ? File(imgProfile!.path) : null,
                        width: 250.w,
                        height: 250.h,
                        fit: BoxFit.contain, //ปรับรูปให้เท่าขนาดข้างบน
                      ),
                      // Callback เมื่อมีการอัปโหลดรูป
                      onUpload: (val) {
                        setState(() {
                          imgProfile = val;
                          isEdited = true; //ตรวจการอัปรูป
                        });
                      },
                    ),
                  ),
                  if (isRequiredProfile) ...[
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      'กรุณาเลือกภาพ',
                      style: AppStyle.txtError,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                  ],
                  SizedBox(
                    height: 16.h,
                  ),
                  // Textfield สำหรับชื่อนามสกุล
                  BaseTextField(
                    fieldKey: FieldUserInfo.name,
                    initialValue: fullname,
                    label: "ชื่อ-นามสกุล",
                    isShowLabelField: true,
                    maxLines: 1,
                    maxLength: 30,
                    counterText: '',
                    validator: Validators.combine(
                      [
                        Validators.withMessage(
                          "กรุณากรอกชื่อ-นามสกุล",
                          Validators.isEmpty,
                        ),
                      ],
                    ),
                    onChanged: (val) {
                      setState(() {
                        fullname = val;
                        isEdited =
                            true; // ตั้งค่า isEdited เป็น true เมื่อมีการแก้ไขชื่อนามสกุล
                      });
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Textfield สำหรับเบอร์โทรศัพท์
                  BaseTextField(
                    fieldKey: FieldUserInfo.phone,
                    initialValue: phone,
                    label: "เบอร์โทรศัพท์",
                    placeholder: "0xxxxxxxxx",
                    counterText: '',
                    textInputType: TextInputType.phone,
                    maxLength: 10,
                    isShowLabelField: true,
                    validator: Validators.combine(
                      [
                        Validators.withMessage(
                          "กรุณากรอกเบอร์โทรศัพท์",
                          Validators.isEmpty,
                        ),
                        Validators.withMessage(
                          "เบอร์โทรศัพท์ต้องขึ้นต้นด้วย 0",
                          Validators.isValidPhoneNumberStartsWith,
                        ),
                        Validators.withMessage(
                          "กรอกเบอร์โทรศัพท์ 9 หลักหรือ 10 หลัก",
                          Validators.isValidPhoneNumberLength,
                        ),
                      ],
                    ),
                    onChanged: (val) {
                      setState(() {
                        phone = val;
                        isEdited =
                            true; // ตั้งค่า isEdited เป็น true เมื่อมีการแก้ไขเบอร์
                      });
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // ถ้าไม่ใช่ร้านเภสัชกร แสดง Textfield สำหรับที่อยู่
                  if (!isPharmacy) ...[
                    BaseTextField(
                      fieldKey: FieldUserInfo.address,
                      controller: addressController,
                      label: "ที่อยู่",
                      isShowLabelField: true,
                      placeholder: "กดเพื่อเลือกตำแหน่งที่อยู่",
                      isReadOnly: isTextFieldReadOnly,
                      suffixIcon: IconButton(
                        icon: Assets.icons.icEdit.svg(),
                        onPressed: () {
                          setState(() {
                            isTextFieldReadOnly =
                                !isTextFieldReadOnly; // เปลี่ยนสถานะ isReadOnly โดยสลับค่า
                          });
                        },
                      ),

                      // Callback เมื่อที่อยู่ถูกแตะ จะเปิดหน้าต่างเลือกที่อยู่
                      onTap: () async {
                        if (isTextFieldReadOnly) {
                          final result =
                              await ref.read(baseUtilsProvider).getLocation();
                          result.when((success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MapLocationPicker(
                                    apiKey:
                                        "AIzaSyAqyETt9iu7l5QioWz5iwEbzrallQrpzLs",
                                    popOnNextButtonTaped: true,
                                    currentLatLng: LatLng(
                                        success.latitude, success.longitude),
                                    // Callback เมื่อเลือกที่อยู่
                                    onNext: (GeocodingResult? result) {
                                      if (result != null) {
                                        Location location =
                                            result.geometry.location;
                                        addressController.text =
                                            result.formattedAddress.toString();
                                        ref
                                            .read(
                                              profileControllerProvider
                                                  .notifier,
                                            )
                                            .setLatAndLongUser(
                                              location.lat,
                                              location.lng,
                                            );
                                      }
                                    },
                                    // Callback เมื่อเลือกที่อยู่จาก suggestion
                                    onSuggestionSelected:
                                        (PlacesDetailsResponse? result) {
                                      if (result != null) {
                                        setState(() {
                                          result.result.formattedAddress ?? "";
                                        });
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                          }, (error) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return BaseDialog(
                                  message: error.message,
                                );
                              },
                            );
                          });
                        }
                      },
                      onChanged: (val) {
                        // เพิ่ม listener สำหรับ addressController
                        addressController.addListener(() {
                          isEdited = true; // ตั้งค่า isEdited เป็น true
                        });
                      },

                      validator: Validators.combine(
                        [
                          Validators.withMessage(
                            "กรุณาเลือกตำแหน่งที่อยู่",
                            Validators.isEmpty,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    //เพิ่มแพ้ยา
                    BaseTextField(
                      fieldKey: FieldUserInfo.allergy,
                      initialValue: allergy,
                      label: "ประวัติการแพ้ยา/แพ้อาหาร",
                      maxLines: 5,
                      isShowLabelField: true,
                      validator: Validators.combine(
                        [
                          Validators.withMessage(
                            "กรุณาระบุประวัติการแพ้ยา/แพ้อาหาร",
                            Validators.isEmpty,
                          ),
                        ],
                      ),
                      onChanged: (val) {
                        setState(() {
                          allergy = val;
                          isEdited =
                              true; // ตั้งค่า isEdited เป็น true เมื่อมีการแก้ไขเบอร์
                        });
                      },
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                  // ถ้าเป็นร้านเภสัชกร แสดง Textfield สำหรับเลขใบอนุญาต
                  if (isPharmacy) ...[
                    BaseTextField(
                      fieldKey: FieldUserInfo.licensePharmacy,
                      initialValue: licensePharmacy,
                      label: "เลขที่ใบอนุญาตเภสัชกร",
                      maxLines: 1,
                      maxLength: 5,
                      counterText: '',
                      textInputType: TextInputType.phone,
                      isShowLabelField: true,
                      validator: Validators.combine(
                        [
                          Validators.withMessage(
                            "กรุณากรอกเลขที่ใบอนุญาตเภสัชกร",
                            Validators.isEmpty,
                          ),
                        ],
                      ),
                      onChanged: (val) {
                        setState(() {
                          licensePharmacy = val;
                          isEdited = true; // ตั้งค่า isEdited เป็น true
                        });
                      },
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    // Widget สำหรับอัปโหลดรูปใบอนุญาต
                    BaseUploadImage(
                      label: 'รูปใบอนุญาตเภสัชกร',
                      // Callback เมื่อมีการอัปโหลดรูป
                      onUpload: (val) {
                        setState(() {
                          licenseFile = val;
                          isEdited = true; // ตั้งค่า isEdited เป็น true
                        });
                      },
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    // แสดงรูปใบอนุญาต
                    InteractiveViewer(
                      child: BaseImageView(
                        url: licenseFile != null ? null : licensePharmacyImg,
                        file: licenseFile != null
                            ? File(licenseFile!.path)
                            : null,
                        width: 350.w,
                        //height: 350.h,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),

                    if (isRequiredLicensePharmacy) ...[
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'กรุณาเลือกรูปภาพ',
                        style: AppStyle.txtError,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                    ],
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                  BaseButton(
                    //ปุ่มที่กดเพื่ออัพเดทข้อมูลขึ้น Firebase
                    onTap: () async {
                      if (formKey.currentState!.validate() && isEdited) {
                        final result = await ref
                            .read(profileControllerProvider.notifier)
                            .onUpdateUserInfo(imgProfile, licenseFile);

                        if (result) {
                          await ref
                              .read(profileControllerProvider.notifier)
                              .onGetUserInfo();
                          await ref
                              .read(profileControllerProvider.notifier)
                              .onGetPharmacyStore();

                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'แก้ไขสำเร็จ',
                                onClick: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'แก้ไขไม่สำเร็จ',
                              );
                            },
                          );
                        }
                      } else {
                        // แสดงข้อความแจ้งเตือนว่าไม่มีการแก้ไข
                        showDialog(
                          context: context,
                          builder: (_) {
                            return BaseDialog(
                              message: 'ไม่มีการแก้ไขข้อมูล',
                            );
                          },
                        );
                      }
                    },
                    text: 'ยืนยันแก้ไข',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
