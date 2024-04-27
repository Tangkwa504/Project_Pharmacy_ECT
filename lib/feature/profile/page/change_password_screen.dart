import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_change_password_enum.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

// สร้าง Widget ที่ใช้ในการเปลี่ยนรหัสผ่าน
class ChangePasswordScreen extends ConsumerStatefulWidget {
  static const routeName = 'ChangePasswordScreen';

  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends BaseConsumerState<ChangePasswordScreen> {
  // ตัวแปรที่ใช้ในการรับข้อมูลจาก Textfield
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final formKey = GlobalKey<BaseFormState>();
  bool isHideCurrentPassword = false;
  bool isHidePassword = false;
  bool isHidePasswordConfirm = false;

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลผู้ใช้จาก ProfileController
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );

    // สร้างหน้าจอด้วย BaseScaffold
    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'เปลี่ยนรหัสผ่าน',
          style: AppStyle.txtHeader3,
        ),
      ),
      // สร้าง Body ด้วย BaseForm
      bodyBuilder: (context, constrained) {
        return BaseForm(
          key: formKey,
          onChanged:
              ref.read(authenticationControllerProvider.notifier).onChanged,
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              children: [
                // Textfield สำหรับรหัสผ่านปัจจุบัน
                BaseTextField(
                  fieldKey: FieldChangePassword.currentPassword,
                  label: 'รหัสผ่านปัจจุบัน',
                  controller: currentPassword,
                  isShowLabelField: true,
                  prefixIcon: Assets.icons.icLock.svg(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isHideCurrentPassword = !isHideCurrentPassword;
                      });
                    },
                    child: isHideCurrentPassword
                        ? Assets.icons.icEye.svg()
                        : Assets.icons.icEyeSlash.svg(),
                  ),
                  isObscureText: !isHideCurrentPassword,
                  validator: Validators.combine(
                    [
                      Validators.withMessage(
                        "กรุณากรอกรหัสผ่านปัจจุบัน",
                        Validators.isEmpty,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                // Textfield สำหรับรหัสผ่านใหม่
                BaseTextField(
                  fieldKey: FieldChangePassword.newPassword,
                  label: 'รหัสผ่านใหม่',
                  controller: newPassword,
                  isShowLabelField: true,
                  prefixIcon: Assets.icons.icLock.svg(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isHidePassword = !isHidePassword;
                      });
                    },
                    child: isHidePassword
                        ? Assets.icons.icEye.svg()
                        : Assets.icons.icEyeSlash.svg(),
                  ),
                  isObscureText: !isHidePassword,
                  validator: Validators.combine(
                    [
                      Validators.withMessage(
                        "กรุณากรอกรหัสผ่านใหม่",
                        Validators.isEmpty,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                // Textfield สำหรับยืนยันรหัสผ่านใหม่
                BaseTextField(
                  label: 'ยืนยันรหัสผ่านใหม่',
                  controller: confirmPassword,
                  prefixIcon: Assets.icons.icLock.svg(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isHidePasswordConfirm = !isHidePasswordConfirm;
                      });
                    },
                    child: isHidePasswordConfirm
                        ? Assets.icons.icEye.svg()
                        : Assets.icons.icEyeSlash.svg(),
                  ),
                  isObscureText: !isHidePasswordConfirm,
                  isShowLabelField: true,
                  validator: Validators.combine(
                    [
                      Validators.withMessage(
                        "กรุณากรอกรหัสผ่านใหม่อีกครั้ง",
                        Validators.isEmpty,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                // ปุ่มสำหรับยืนยันการเปลี่ยนรหัสผ่าน
                BaseButton(
                  onTap: () {
                    // บันทึกข้อมูลและทำการเปลี่ยนรหัสผ่าน
                    formKey.currentState?.save(
                      onSave: (val) async {
                        // ตรวจสอบว่ารหัสผ่านปัจจุบันถูกต้องหรือไม่
                        if (currentPassword.text != userInfo?.password) {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'รหัสผ่านปัจจุบันไม่ถูกต้อง',
                              );
                            },
                          );
                          return;
                        }

                        // ตรวจสอบว่ารหัสผ่านใหม่และการยืนยันรหัสผ่านตรงกันหรือไม่
                        if (newPassword.text != confirmPassword.text) {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'รหัสผ่านใหม่ไม่ตรงกัน',
                              );
                            },
                          );
                          return;
                        }

                        // เรียกเมธอดที่ใช้ในการเปลี่ยนรหัสผ่าน
                        final result = await ref
                            .read(authenticationControllerProvider.notifier)
                            .onChangePassword();

                        if (result) {
                          // แสดง Dialog เมื่อเปลี่ยนรหัสผ่านสำเร็จ
                          await showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message:
                                    'เปลี่ยนรหัสผ่านเรียบร้อย กรุณา Login ใหม่อีกครั้ง',
                                onClick: () async {
                                  // ทำการ Logout และเปลี่ยนหน้าจอไปที่ MainScreen
                                  final result = await ref
                                      .read(
                                        authenticationControllerProvider
                                            .notifier,
                                      )
                                      .onLogout();

                                  if (result) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      MainScreen.routeName,
                                      (route) => false,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        } else {
                          // แสดง Dialog เมื่อไม่สามารถเปลี่ยนรหัสผ่านได้
                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message:
                                    'ไม่สามารถเปลี่ยนรหัสผ่านได้\nรหัสผ่านต้องมากกว่าหรือเท่ากับ 6 ตัวอักษร',
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                  text: "ยืนยัน",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
