import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_switch_button.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

import 'package:pharmacy_online/base_widget/base_checkbox.dart';

class SignUpStep2Widget extends ConsumerStatefulWidget {
  static const routeName = 'SignUpStep2Widget';

  final Function(XFile? imgProfile, XFile? licenseFile) onTap;
  final VoidCallback onBack;

  const SignUpStep2Widget({
    super.key,
    required this.onTap,
    required this.onBack,
  });

  @override
  _SignUpStep2WidgetState createState() => _SignUpStep2WidgetState();
}

class _SignUpStep2WidgetState extends ConsumerState<SignUpStep2Widget> {
  XFile? licenseFile;
  XFile? imgProfile;
  bool isRequiredProfile = true;
  bool isRequiredLicensePharmacy = true;
  TextEditingController addressController = TextEditingController();

  bool isValidated = false; //ตรวจสอบ
  bool isTextFieldReadOnly = true; // เปิด-ปิด readonly ที่อยู๋
  bool showSuffixIcon = false; //โชว์ไอค่อนแก้ที่อยู่
  bool isAddressEmpty = true; //เช็คช่องว่างที่อยู่

  bool isChecked = false;

  @override
  void dispose() {
    super.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final baseFormData = ref.watch(
          authenticationControllerProvider.select(
            (value) => value.baseFormData,
          ),
        );

        final role = baseFormData
            ?.getValue<List<SwitchButtonItem>>(FieldSignUp.role)
            ?.first
            .value;

        final isPharmacy = role == AuthenticationType.pharmacy.name;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Widget สำหรับอัปโหลดรูปโปรไฟล์
            Container(
              padding: const EdgeInsets.all(8).r,
              decoration: BoxDecoration(
                // border: Border.all(
                //   color: AppColor.themePrimaryColor,
                //   width: 1, // red as border color
                // ),
                border: imgProfile == null
                    ? Border.all(
                        color: Colors
                            .transparent) // ไม่แสดงเส้นขอบถ้า imgPreview เป็น SvgPicture
                    : Border.all(
                        color: AppColor.themePrimaryColor,
                        width: 1,
                      ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    16,
                  ),
                ),
              ),
              child: BaseUploadImageButton(
                imgPreview: //Assets.icons.icProfile.svg(),
                    SizedBox(
                  width: 120,
                  height: 120,
                  child: Assets.icons.icProfile.svg(),
                ),
                onUpload: (val) {
                  setState(() {
                    imgProfile = val;
                    isRequiredProfile = false;
                  });
                },
              ),
            ),
            if (isRequiredProfile) ...[
              // SizedBox(
              //   height: 8.h,
              // ),
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
            BaseTextField(
              placeholder: "ชื่อ-นามสกุล",
              fieldKey: FieldSignUp.name,
              label: "ชื่อ-นามสกุล",
              isShowLabelField: true,
              maxLines: 1,
              maxLength: 30,
              counterText: '',
              validator: (value) {
                final validators = Validators.combine(
                  [
                    Validators.withMessage(
                      "กรุณากรอกชื่อ-นามสกุล",
                      Validators.isEmpty,
                    ),
                  ],
                );
                // ตรวจสอบ validator
                //validators(value) จะคืนค่า null เมื่อผ่านเงื่อนไขของ validators ทั้งหมด
                //และจะคืนค่าข้อความของ validator ที่ไม่ผ่านเมื่อเงื่อนไขใดเงื่อนไขหนึ่งไม่ถูกต้อง
                if (validators(value) == null) {
                  isValidated = true; //ตรวจสอบแล้วผ่านหมด
                } else {
                  isValidated = false;
                }

                // ส่งค่ากลับเป็นข้อความของ validator ที่ผ่านได้
                return validators(value);
              },
            ),
            SizedBox(
              height: 16.h,
            ),
            BaseTextField(
              fieldKey: FieldSignUp.phone,
              label: "เบอร์โทรศัพท์",
              isShowLabelField: true,
              textInputType: TextInputType.phone,
              maxLength: 10,
              counterText: '',
              placeholder: "0xxxxxxxxx",
              validator: (value) {
                final validators = Validators.combine(
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
                );

                // ตรวจสอบ validator
                //validators(value) จะคืนค่า null เมื่อผ่านเงื่อนไขของ validators ทั้งหมด
                //และจะคืนค่าข้อความของ validator ที่ไม่ผ่านเมื่อเงื่อนไขใดเงื่อนไขหนึ่งไม่ถูกต้อง
                if (validators(value) == null) {
                  isValidated = true; //ตรวจสอบแล้วผ่านหมด
                } else {
                  isValidated = false;
                }

                // ส่งค่ากลับเป็นข้อความของ validator ที่ผ่านได้
                return validators(value);
              },
            ),
            SizedBox(
              height: 16.h,
            ),
            if (!isPharmacy) ...[
              BaseTextField(
                fieldKey: FieldSignUp.address,
                controller: addressController,
                label: "ที่อยู่",
                isShowLabelField: true,
                placeholder: "กดเพื่อเลือกตำแหน่งที่อยู่",
                isReadOnly: isTextFieldReadOnly,
                suffixIcon: showSuffixIcon
                    ? IconButton(
                        icon: Assets.icons.icEdit.svg(),
                        onPressed: () {
                          setState(() {
                            isTextFieldReadOnly =
                                !isTextFieldReadOnly; // เปลี่ยนสถานะ isReadOnly โดยสลับค่า
                          });
                        },
                      )
                    : null,
                onTap: () async {
                  showSuffixIcon = true;
                  if (isTextFieldReadOnly) {
                    // ตรวจสอบว่าสามารถแก้ไขได้หรือไม่
                    final result =
                        await ref.read(baseUtilsProvider).getLocation();
                    result.when((success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MapLocationPicker(
                              apiKey: "AIzaSyAqyETt9iu7l5QioWz5iwEbzrallQrpzLs",
                              popOnNextButtonTaped: true,
                              currentLatLng:
                                  LatLng(success.latitude, success.longitude),
                              onNext: (GeocodingResult? result) {
                                if (result != null) {
                                  Location location = result.geometry.location;
                                  addressController.text =
                                      result.formattedAddress.toString();
                                  ref
                                      .read(
                                        authenticationControllerProvider
                                            .notifier,
                                      )
                                      .setLatAndLongUser(
                                        location.lat,
                                        location.lng,
                                      );
                                }
                              },
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
                  } else {
                    // ตรวจสอบว่า Address field ว่างหรือไม่
                    isAddressEmpty = addressController.text.isEmpty;
                    if (isAddressEmpty) {
                      setState(() {
                        isTextFieldReadOnly = true;
                        showSuffixIcon = false;
                      });
                    }
                  }
                },
                validator: (value) {
                  final validators = Validators.combine(
                    [
                      Validators.withMessage(
                        "กรุณาเลือกตำแหน่งที่อยู่",
                        Validators.isEmpty,
                      ),
                    ],
                  );
                  // ตรวจสอบ validator
                  //validators(value) จะคืนค่า null เมื่อผ่านเงื่อนไขของ validators ทั้งหมด
                  //และจะคืนค่าข้อความของ validator ที่ไม่ผ่านเมื่อเงื่อนไขใดเงื่อนไขหนึ่งไม่ถูกต้อง
                  if (validators(value) == null) {
                    isValidated = true; //ตรวจสอบแล้วผ่านหมด
                  } else {
                    isValidated = false;
                  }

                  // ส่งค่ากลับเป็นข้อความของ validator ที่ผ่านได้
                  return validators(value);
                },
              ),
              SizedBox(
                height: 16.h,
              ),

              //เพิ่มแพ้ยา
              BaseTextField(
                fieldKey: FieldSignUp.allergy,
                label: "ประวัติการแพ้ยา/แพ้อาหาร",
                isShowLabelField: true,
                maxLines: 5,
                counterText: '',
                placeholder: "ระบุยาที่แพ้หรืออาหารที่แพ้หรือกรอก - ถ้าไม่มี",
                validator: (value) {
                  final validators = Validators.combine(
                    [
                      Validators.withMessage(
                        "กรุณาระบุประวัติการแพ้",
                        Validators.isEmpty,
                      ),
                    ],
                  );

                  // ตรวจสอบ validator
                  //validators(value) จะคืนค่า null เมื่อผ่านเงื่อนไขของ validators ทั้งหมด
                  //และจะคืนค่าข้อความของ validator ที่ไม่ผ่านเมื่อเงื่อนไขใดเงื่อนไขหนึ่งไม่ถูกต้อง
                  if (validators(value) == null) {
                    isValidated = true; //ตรวจสอบแล้วผ่านหมด
                  } else {
                    isValidated = false;
                  }

                  // ส่งค่ากลับเป็นข้อความของ validator ที่ผ่านได้
                  return validators(value);
                },
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
            if (isPharmacy) ...[
              BaseTextField(
                fieldKey: FieldSignUp.licensePharmacy,
                label: "เลขที่ใบอนุญาตเภสัชกร",
                placeholder: "เลขที่ใบอนุญาตเภสัชกร",
                isShowLabelField: true,
                maxLines: 1,
                maxLength: 5,
                counterText: '',
                textInputType: TextInputType.phone,
                validator: (value) {
                  final validators = Validators.combine(
                    [
                      Validators.withMessage(
                        "กรุณากรอกเลขที่ใบอนุญาตเภสัชกร",
                        Validators.isEmpty,
                      ),
                    ],
                  );
                  // ตรวจสอบ validator
                  //validators(value) จะคืนค่า null เมื่อผ่านเงื่อนไขของ validators ทั้งหมด
                  //และจะคืนค่าข้อความของ validator ที่ไม่ผ่านเมื่อเงื่อนไขใดเงื่อนไขหนึ่งไม่ถูกต้อง
                  if (validators(value) == null) {
                    isValidated = true; //ตรวจสอบแล้วผ่านหมด
                  } else {
                    isValidated = false;
                  }

                  // ส่งค่ากลับเป็นข้อความของ validator ที่ผ่านได้
                  return validators(value);
                },
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseUploadImage(
                label: 'รูปใบอนุญาตเภสัชกร',
                onUpload: (val) {
                  setState(() {
                    licenseFile = val;
                    isRequiredLicensePharmacy = false;
                  });
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              if (licenseFile != null) ...[
                BaseImageView(
                  file: File(licenseFile!.path),
                  width: 250.w,
                  //height: 250.h,
                  fit: BoxFit.contain,
                ),
              ],
              if (isRequiredLicensePharmacy) ...[
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
            ],
            //เพิ่มปุ่ม checkbox
            Row(
              children: [
                BaseCheckBox(
                  fieldKey: FieldSignUp.checkBox,
                  isEnabled: true,
                  initialValue: false,
                  onChanged: (val) {
                    if (val == true) {
                      setState(() {
                        isChecked = true;
                      });
                    } else {
                      setState(() {
                        isChecked = false;
                      });
                    }
                  },
                ),
                Text(
                  '  ฉันยินยอมให้เก็บรวบรวม ใช้ และเปิดเผยข้อมูลส่วนบุคคล\n  เพื่อใช้งานภายในแพลตฟอร์ม',
                  style: AppStyle.txtCaptionlight,
                ),
              ],
            ),

            SizedBox(
              height: 16.h,
            ),
            Row(
              children: [
                Expanded(
                  child: BaseButton(
                    buttonType: ButtonType.secondary,
                    onTap: () async {
                      widget.onBack();
                    },
                    text: 'กลับ',
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: BaseButton(
                    onTap: () async {
                      if (isValidated) {
                        if (isPharmacy) {
                          isRequiredLicensePharmacy =
                              licenseFile != null ? false : true;
                        }
                        if (isChecked) {
                          isRequiredProfile = imgProfile != null ? false : true;

                          setState(() {});

                          if (imgProfile != null) {
                            if (isPharmacy && licenseFile == null) {
                              return;
                            }

                            widget.onTap(imgProfile, licenseFile);
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'กรุณากดยินยอมให้ใช้ข้อมูล',
                              );
                            },
                          );

                          return;
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return BaseDialog(
                              message: 'กรุณากรอกข้อมูลให้ครบถ้วนและถูกต้อง',
                            );
                          },
                        );

                        return;
                      }
                    },
                    text: 'ยืนยัน',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
