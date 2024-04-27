import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_style.dart';
//import 'package:pharmacy_online/feature/authentication/page/sign_in_screen.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class SignUpSuccessfulScreen extends ConsumerWidget {
  static const routeName = 'SignUpSuccessfulScreen';

  const SignUpSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      bodyBuilder: (context, constrained) {
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
                'ทำการสมัครเรียบร้อย!!!',
                style: AppStyle.txtHeader3,
              ),
              SizedBox(
                height: 8.h,
              ),
              BaseButton(
                minWidth: 100.w,
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainScreen.routeName,
                    (route) => false,
                    //SignInScreen.routeName,
                    //(route) => route.settings.name == MainScreen.routeName,
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
