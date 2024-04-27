import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
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
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class AddMedicineWarehouseScreen extends ConsumerStatefulWidget {
  static const routeName = 'AddMedicineWarehouseScreen';

  // เป็น `ConsumerStatefulWidget` เพื่อเข้าถึง providers ใน Riverpod
  const AddMedicineWarehouseScreen({super.key});

  @override
  // จัดการ state ของหน้าจอ
  _AddMedicineWarehouseScreenState createState() =>
      _AddMedicineWarehouseScreenState();
}

class _AddMedicineWarehouseScreenState
    extends BaseConsumerState<AddMedicineWarehouseScreen> {
  // มี `formKey` สำหรับจัดการฟอร์ม
  final formKey = GlobalKey<BaseFormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  XFile? medicineFIle; //เก็บรูปยา

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบว่าผู้ใช้เป็นแอดมิน เพื่อกำหนดว่าไม่ต้องแสดงช่องกรอกราคา
    final isAdmin = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'เพิ่มยา',
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
                      border: medicineFIle == null
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

                  // ช่องกรอกราคา
                  if (!isAdmin) ...[
                    BaseTextField(
                      fieldKey: FieldMedicine.price,
                      label: "ราคา",
                      isShowLabelField: true,
                      maxLength: 10,
                      counterText: '',
                      textInputType: TextInputType.number,
                      validator: Validators.combine(
                        [
                          Validators.withMessage(
                            "กรุณากรอกราคายา",
                            Validators.isEmpty,
                          ),
                        ],
                      ),
                    ),
                  ],
                  BaseTextField(
                    fieldKey: FieldMedicine.size,
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
                  // ปุ่มยืนยันเพิ่มยา
                  BaseButton(
                    // onTap ฟังก์ชันเมื่อกดปุ่มยืนยันเพิ่มยา
                    onTap: () async {
                      // บันทึกข้อมูลในฟอร์ม
                      formKey.currentState?.save(
                        // onSave ฟังก์ชันจะถูกเรียกเมื่อมีการบันทึกข้อมูลในฟอร์มสำเร็จ
                        onSave: (_) async {
                          // ตรวจสอบว่ามีการอัปโหลดรูปภาพยาหรือไม่ หากไม่มีจะแสดงข้อความแจ้งเตือนให้อัปโหลดรูปภาพยา
                          if (medicineFIle == null) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return BaseDialog(
                                  message: 'กรุณาเลือกรูปภาพ',
                                );
                              },
                            );
                            return;
                          }

                          // เรียกใช้ฟังก์ชัน addMedicineWarehouse เพื่อเพิ่มยา
                          final result = await ref
                              // read ข้อมูลจาก provider
                              .read(storeControllerProvider.notifier)
                              // เรียกใช้ฟังก์ชัน addMedicineWarehouse
                              .addMedicineWarehouse(medicineFIle!);

                          // ตรวจสอบว่าการเพิ่มยาสำเร็จหรือไม่ หากสำเร็จจะแสดงข้อความแจ้งเตือนสำเร็จและปิดหน้าจอ
                          if (result) {
                            await ref
                                // รีเฟรชข้อมูลยาในคลังกลาง
                                .read(storeControllerProvider.notifier)
                                .onGetCentralMedicineWarehouse();
                            await ref
                                // รีเฟรชข้อมูลยาในคลัง
                                .read(storeControllerProvider.notifier)
                                .onGetMedicineWarehouse();

                            showDialog(
                              context: context,
                              builder: (_) {
                                return BaseDialog(
                                  message: 'เพิ่มยาสำเร็จ',
                                  onClick: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          } else {
                            // หากการเพิ่มยาไม่สำเร็จจะแสดงข้อความแจ้งเตือนไม่สำเร็จ
                            showDialog(
                              context: context,
                              builder: (_) {
                                return BaseDialog(
                                  message: 'เพิ่มยาไม่สำเร็จ',
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
