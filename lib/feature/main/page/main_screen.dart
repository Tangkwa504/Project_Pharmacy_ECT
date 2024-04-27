import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_in_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_up_screen.dart';
import 'package:pharmacy_online/feature/dashboard/page/dashboard_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class MainScreen extends ConsumerStatefulWidget {
  static const routeName = "MainScreen";

  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends BaseConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      //bgColor: const Color.fromARGB(255, 246, 255, 246), // Set background color
      bodyBuilder: (context, constrained) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.imgs.imgLogoHome.image(),
              Text(
                'PHARMACY ONLINE',
                style: AppStyle.txtHeaderLogo,
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseButton(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    SignInScreen.routeName,
                  );
                },
                text: 'เข้าสู่ระบบ',
                buttonType: ButtonType.tertiary,
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseButton(
                onTap: () {
                  ref
                      .read(authenticationControllerProvider.notifier)
                      .clearForm();
                  Navigator.of(context).pushNamed(
                    SignUpScreen.routeName,
                  );
                },
                text: 'สมัครสมาชิก',
              ),
              SizedBox(
                height: 16.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    DashboardScreen.routeName,
                    (route) => false,
                  );
                },
                child: Text(
                  'ข้าม',
                  style: AppStyle.txtBody2,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
