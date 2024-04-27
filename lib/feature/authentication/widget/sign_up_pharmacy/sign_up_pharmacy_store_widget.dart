import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class SignUpPharmacyStoreWidget extends ConsumerStatefulWidget {
  static const routeName = 'SignUpPharmacyStoreWidget';

  final Function(
    XFile? storeFile,
    XFile? licenseStoreFile,
    XFile? qrcodeFile,
    TimeOfDay openingTime,
    TimeOfDay closingTime,
  ) onTap;

  final VoidCallback onBack;

  const SignUpPharmacyStoreWidget({
    super.key,
    required this.onTap,
    required this.onBack,
  });

  @override
  _SignUpPharmacyStoreWidgetState createState() =>
      _SignUpPharmacyStoreWidgetState();
}

class _SignUpPharmacyStoreWidgetState
    extends ConsumerState<SignUpPharmacyStoreWidget> {
  TextEditingController addressController = TextEditingController();
  TextEditingController openingController = TextEditingController();
  TextEditingController closingController = TextEditingController();

  XFile? licenseStoreFile, qrcodeFile, storeFile;
  bool isRequiredStore = true,
      isRequiredLicenseStore = true,
      isRequiredQrcode = true;
  TimeOfDay? openingTime, closingTime;

  bool isValidated = false; //ตรวจสอบ
  bool isTextFieldReadOnly = true; // ตรวจสอบตำแหน่งที่อยู่
  bool showSuffixIcon = false; //โชว์ไอค่อนแก้ที่อยู่
  bool isAddressEmpty = true; //เช็คช่องว่างที่อยู่

  @override
  void dispose() {
    super.dispose();
    addressController.dispose();
    openingController.dispose();
    closingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8).r,
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: AppColor.themePrimaryColor,
            //   width: 1, // red as border color
            // ),
            border: storeFile == null
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
            imgPreview: Assets.icons.icAddImg.svg(),
            onUpload: (val) {
              setState(() {
                storeFile = val;
                isRequiredStore = false;
              });
            },
          ),
        ),
        if (isRequiredStore) ...[
          SizedBox(
            height: 8.h,
          ),
          Text(
            'กรุณาเลือกภาพ',
            style: AppStyle.txtError,
          ),
        ],
        SizedBox(
          height: 16.h,
        ),
        BaseTextField(
          fieldKey: FieldSignUp.nameStore,
          label: "ชื่อร้าน",
          isShowLabelField: true,
          maxLines: 1,
          maxLength: 30,
          counterText: '',
          validator: (value) {
            final validators = Validators.combine(
              [
                Validators.withMessage(
                  "กรุณากรอกชื่อร้าน",
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
          fieldKey: FieldSignUp.addressStore,
          controller: addressController,
          placeholder: "กดเพื่อเลือกตำแหน่งที่อยู่",
          label: "ที่อยู่ร้าน",
          isShowLabelField: true,
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
              : IconButton(
                  icon: Assets.icons.icEdit.svg(),
                  onPressed: () {
                    setState(() {
                      isTextFieldReadOnly = true;
                    });
                  },
                ),
          onTap: () async {
            if (isTextFieldReadOnly) {
              showSuffixIcon = true;
              // ตรวจสอบว่าสามารถแก้ไขได้หรือไม่
              final result = await ref.read(baseUtilsProvider).getLocation();

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
                                  authenticationControllerProvider.notifier,
                                )
                                .setLatAndLongPharmacyStore(
                                  location.lat,
                                  location.lng,
                                );
                          }
                        },
                        onSuggestionSelected: (PlacesDetailsResponse? result) {
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
                  "กรุณาระบุตำแหน่งที่อยู่ร้าน",
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
          fieldKey: FieldSignUp.phoneStore,
          label: "เบอร์โทรศัพท์ร้าน",
          maxLength: 10,
          counterText: '',
          isShowLabelField: true,
          textInputType: TextInputType.phone,
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
        BaseTextField(
          label: "เวลาเปิดทำการ",
          isReadOnly: true,
          isShowLabelField: true,
          placeholder: "กดเพื่อเลือกเวลาเปิดร้าน",
          textInputType: TextInputType.datetime,
          controller: openingController,
          onTap: () async {
            openingTime = await showTimePicker(
              context: context,
              initialTime: openingTime ?? TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );

            setState(() {
              openingController.text = openingTime == null
                  ? ''
                  : '${openingTime?.hour.toString().padLeft(2, '0')}:${openingTime?.minute.toString().padLeft(2, '0')}';
            });
          },
        ),
        SizedBox(
          height: 16.h,
        ),
        BaseTextField(
          label: "เวลาปิดทำการ",
          isShowLabelField: true,
          isReadOnly: true,
          placeholder: "กดเพื่อเลือกเวลาปิดร้าน",
          textInputType: TextInputType.datetime,
          controller: closingController,
          onTap: () async {
            closingTime = await showTimePicker(
              context: context,
              initialTime: closingTime ?? TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );

            setState(() {
              closingController.text = closingTime == null
                  ? ''
                  : '${closingTime?.hour.toString().padLeft(2, '0')}:${closingTime?.minute.toString().padLeft(2, '0')}';
            });
          },
        ),
        SizedBox(
          height: 16.h,
        ),
        BaseTextField(
          fieldKey: FieldSignUp.licensePharmacyStore,
          label: "เลขที่ใบอนุญาตร้านขายยา",
          isShowLabelField: true,
          maxLines: 1,
          maxLength: 30,
          counterText: '',
          validator: (value) {
            final validators = Validators.combine(
              [
                Validators.withMessage(
                  "กรุณากรอกเลขที่ใบอนุญาตร้านขายยา",
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
          label: 'รูปใบอนุญาตร้านขายยา',
          onUpload: (val) {
            setState(() {
              licenseStoreFile = val;
              isRequiredLicenseStore = false;
            });
          },
        ),
        SizedBox(
          height: 8.h,
        ),
        if (licenseStoreFile != null) ...[
          BaseImageView(
            file: File(licenseStoreFile!.path),
            width: 250.w,
            //height: 250.h,
            fit: BoxFit.contain,
          ),
        ],
        if (isRequiredLicenseStore) ...[
          Text(
            'กรุณาเลือกรูปภาพ',
            style: AppStyle.txtError,
          ),
          SizedBox(
            height: 16.h,
          ),
        ],
        SizedBox(
          height: 16.h,
        ),
        BaseUploadImage(
          label: 'รูป QRcode รับเงิน',
          onUpload: (val) {
            setState(() {
              qrcodeFile = val;
              isRequiredQrcode = false;
            });
          },
        ),
        if (qrcodeFile != null) ...[
          SizedBox(
            height: 8.h,
          ),
          BaseImageView(
            file: File(qrcodeFile!.path),
            width: 250.w,
            //height: 250.h,
            fit: BoxFit.contain,
          ),
        ],
        if (isRequiredQrcode) ...[
          SizedBox(
            height: 8.h,
          ),
          Text(
            'กรุณาเลือกรูปภาพ',
            style: AppStyle.txtError,
          ),
        ],
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
                    isRequiredStore = storeFile != null ? false : true;
                    isRequiredLicenseStore =
                        licenseStoreFile != null ? false : true;
                    isRequiredQrcode = qrcodeFile != null ? false : true;

                    if (openingTime == null) {
                      Fluttertoast.showToast(
                        msg: "กรุณาระบุเวลาร้านเปิดทำการ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }
                    if (closingTime == null) {
                      Fluttertoast.showToast(
                        msg: "กรุณาระบุเวลาร้านปิดทำการ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }

                    setState(() {});

                    if (storeFile != null &&
                        licenseStoreFile != null &&
                        qrcodeFile != null &&
                        openingTime != null &&
                        closingTime != null) {
                      widget.onTap(
                        storeFile,
                        licenseStoreFile,
                        qrcodeFile,
                        openingTime!,
                        closingTime!,
                      );
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
  }
}
