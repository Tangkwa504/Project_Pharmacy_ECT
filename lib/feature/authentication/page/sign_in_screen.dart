import 'package:flutter/material.dart';
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
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_in_enum.dart';
import 'package:pharmacy_online/feature/authentication/page/forgot_password_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_in_successful_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_up_screen.dart';
import 'package:pharmacy_online/feature/authentication/widget/row_text_clickable_widget.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const routeName = 'SignInScreen';

  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final formKey = GlobalKey<BaseFormState>();
  bool isHidePassword = false;
  TextEditingController passwordController = TextEditingController();
  bool isValidated = false; //ตรวจสอบ

  @override
  void dispose() {
    formKey.currentState?.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'เข้าสู่ระบบ',
          style: AppStyle.txtHeader3,
        ),
        elevation: 0.0,
        bgColor: Colors.transparent,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: BaseForm(
              key: formKey,
              onChanged:
                  ref.read(authenticationControllerProvider.notifier).onChanged,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BaseTextField(
                    fieldKey: FieldSignIn.email,
                    label: 'อีเมล',
                    isShowLabelField: true,
                    validator: Validators.combine([
                      Validators.withMessage(
                        "กรุณากรอกอีเมล",
                        Validators.isEmpty,
                      ),
                      Validators.withMessage(
                        "กรุณากรอกอีเมลให้ถูกต้อง",
                        Validators.isValidEmail,
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  BaseTextField(
                    fieldKey: FieldSignIn.password,
                    label: 'รหัสผ่าน',
                    controller: passwordController,
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
                          "กรุณากรอกรหัสผ่าน",
                          Validators.isEmpty,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ForgotPasswordScreen.routeName,
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'ลืมรหัสผ่าน',
                        style: AppStyle.txtCaption
                            .copyWith(color: AppColor.themePrimaryColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  BaseButton(
                    //ปุ่ม login
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        final result = await ref
                            .read(authenticationControllerProvider.notifier)
                            .onSignIn();
                        //ตรวจสอบ
                        if (result) {
                          //เรียกฟังชั่นตรวจสอบการ Login
                          await ref
                              .read(profileControllerProvider.notifier)
                              .onGetUserInfo();

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            SignInSuccessfulScreen.routeName,
                            (route) =>
                                route.settings.name == MainScreen.routeName,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
                              );
                            },
                          );
                        }
                      }
                    },
                    text: 'เข้าสู่ระบบ',
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  RowTextClickableWidget(
                    onTap: () {
                      ref
                          .read(authenticationControllerProvider.notifier)
                          .clearForm();
                      Navigator.of(context).pushNamed(
                        SignUpScreen.routeName,
                      );
                    },
                    label1: 'ยังไม่มีบัญชี?',
                    label2: 'สมัครสมาชิก',
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
