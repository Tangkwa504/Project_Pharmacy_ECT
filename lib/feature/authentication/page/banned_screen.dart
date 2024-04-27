import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class BannedScreen extends ConsumerStatefulWidget {
  static const routeName = 'BannedScreen';

  const BannedScreen({super.key});

  @override
  _BannedScreenState createState() => _BannedScreenState();
}

class _BannedScreenState extends ConsumerState<BannedScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      bodyBuilder: (context, constrined) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.icons.icBannd.svg(width: 150, height: 150),
              SizedBox(
                height: 32.h,
              ),
              Text(
                'บัญชีคุณถูกระงับการใช้งาน\nกรุณาติดต่อ pharmapp.admn@gmail.com',
                style: AppStyle.txtBody2,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseButton(
                width: 100.w,
                onTap: () async {
                  final result = await ref
                      .read(authenticationControllerProvider.notifier)
                      .onLogout();

                  if (result) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      MainScreen.routeName,
                      (route) => false,
                    );
                  }
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
