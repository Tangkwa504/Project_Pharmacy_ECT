import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/enum/field_medicine_enum.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

// คลาสที่ใช้เก็บข้อมูลที่ส่งมาระหว่างหน้าจอแก้ไขยา
class MedicineWarehouseArgs {
  final MedicineResponse medicineItem;

  MedicineWarehouseArgs({
    required this.medicineItem,
  });
}

// หน้าจอแก้ไขยา
class EditMedicineWarehouseScreen extends ConsumerStatefulWidget {
  static const routeName = 'EditMedicineWarehouseScreen';

  final MedicineWarehouseArgs args;

  const EditMedicineWarehouseScreen({
    super.key,
    required this.args,
  });

  @override
  _EditMedicineWarehouseScreenState createState() =>
      _EditMedicineWarehouseScreenState();
}

// State ของหน้าจอแก้ไขยา
class _EditMedicineWarehouseScreenState
    extends BaseConsumerState<EditMedicineWarehouseScreen> {
  final formKey = GlobalKey<BaseFormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  XFile? medicineFIle;

  @override
  Widget build(BuildContext context) {
    final medicineItem = widget.args.medicineItem;
// ดูว่าใช่แอดมินไหม
    final isAdmin = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'แก้ไขข้อมูลยา',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        return BaseForm(
          key: formKey,
          onChanged: ref.read(storeControllerProvider.notifier).onChanged,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8).r,
                    decoration: BoxDecoration(
                      border: Border.all(
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
                      imgPreview: BaseImageView(
                        url: medicineFIle != null
                            ? null
                            : medicineItem.medicineImg,
                        file: medicineFIle != null
                            ? File(medicineFIle!.path)
                            : null,
                        width: 250.w,
                        height: 250.h,
                        fit: BoxFit.contain,
                      ),
                      onUpload: (val) {
                        setState(() {
                          medicineFIle = val;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  BaseTextField(
                    fieldKey: FieldMedicine.name,
                    label: "ชื่อยา",
                    isShowLabelField: true,
                    maxLines: 1,
                    maxLength: 30,
                    counterText: '',
                    initialValue: medicineItem.name,
                    validator: Validators.combine(
                      [
                        Validators.withMessage(
                          "กรุณากรอกชื่อยา",
                          Validators.isEmpty,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),

                  // แสดงช่องกรอกราคา ถ้าไม่ใช่ Admin
                  if (!isAdmin) ...[
                    BaseTextField(
                      fieldKey: FieldMedicine.price,
                      initialValue: '${medicineItem.price}',
                      label: "ราคา",
                      isShowLabelField: true,
                      maxLength: 10,
                      counterText: '',
                      textInputType: TextInputType.number,
                      validator: Validators.combine(
                        [
                          Validators.withMessage(
                            "กรุณากรอกราคา",
                            Validators.isEmpty,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                  BaseTextField(
                    fieldKey: FieldMedicine.size,
                    initialValue:
                        medicineItem.size == null ? '' : '${medicineItem.size}',
                    label: "ขนาดบรรจุ",
                    isShowLabelField: true,
                    maxLines: 1,
                    maxLength: 30,
                    counterText: '',
                    validator: Validators.combine(
                      [
                        Validators.withMessage(
                          "กรุณากรอกขนาดบรรจุของยา",
                          Validators.isEmpty,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  BaseTextField(
                    fieldKey: FieldMedicine.material,
                    initialValue: medicineItem.material == null
                        ? ''
                        : '${medicineItem.material}',
                    label: "ส่วนประกอบ",
                    isShowLabelField: true,
                    validator: Validators.combine(
                      [
                        Validators.withMessage(
                          "กรุณากรอกส่วนประกอบยา",
                          Validators.isEmpty,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  BaseButton(
                    onTap: () async {
                      formKey.currentState?.save(
                        onSave: (_) async {
                          // เรียกใช้ use case สำหรับแก้ไขยา
                          final result = await ref
                              .read(storeControllerProvider.notifier)
                              .editMedicineWarehouse('${medicineItem.id}',
                                  medicineFIle, medicineItem.medicineImg);

                          if (result) {
                            // โหลดข้อมูลคลังยาใหม่หลังจากแก้ไขสำเร็จ
                            await ref
                                .read(storeControllerProvider.notifier)
                                .onGetCentralMedicineWarehouse();
                            await ref
                                .read(storeControllerProvider.notifier)
                                .onGetMedicineWarehouse();

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
                        },
                      );
                    },
                    text: 'ยืนยัน',
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
