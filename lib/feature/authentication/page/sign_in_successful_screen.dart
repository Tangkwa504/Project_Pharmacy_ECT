import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/admin/page/admin_dashboard_screen.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/authentication/page/banned_screen.dart';
import 'package:pharmacy_online/feature/dashboard/page/dashboard_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class SignInSuccessfulScreen extends ConsumerStatefulWidget {
  static const routeName = 'SignInSuccessfulScreen';

  const SignInSuccessfulScreen({super.key});

  @override
  _SignInSuccessfulScreenState createState() => _SignInSuccessfulScreenState();
}

class _SignInSuccessfulScreenState
    extends ConsumerState<SignInSuccessfulScreen> {
  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(
      profileControllerProvider.select(
        (value) => value.userInfo,
      ),
    );

    final isAdmin = userInfo?.role == AuthenticationType.admin.name;

    return BaseScaffold(
      bodyBuilder: (context, constrined) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.icons.icSuccessful.svg(),
              SizedBox(
                height: 32.h,
              ),
              Text(
                'ทำการเข้าสู่ระบบเรียบร้อย',
                style: AppStyle.txtHeader3,
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseButton(
                width: 100.w,
                onTap: () {
                  // ตรวจสอบสถานะของ userInfo
                  if (userInfo?.status == 'cancel') {
                    // ถ้าสถานะเป็น cancel นำทางผู้ใช้ไปยังหน้าจอ BannedScreen และลบทุกทางที่ถูกเรียกใช้
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      BannedScreen.routeName,
                      (route) => false,
                    );
                    return;
                  }
                  // ตรวจสอบว่าผู้ใช้เป็น Admin หรือไม่
                  if (isAdmin) {
                    // ถ้าเป็น Admin นำทางผู้ใช้ไปยังหน้าจอ AdminDashboardScreen และลบทุกทางที่ถูกเรียกใช้
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AdminDashboardScreen.routeName,
                      (route) => false,
                    );
                    return;
                  }
                  // นำทางผู้ใช้ไปยังหน้าจอ DashboardScreen และลบทุกทางที่ถูกเรียกใช้
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    DashboardScreen.routeName,
                    (route) => false,
                  );
                },
                text: 'ยืนยัน',
              ),
            ],
          ),
        );
      },
    );
  }
}
