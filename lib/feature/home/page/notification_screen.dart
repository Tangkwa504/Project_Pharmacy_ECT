import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/home/widget/notificaion_list_widget.dart';

class NotificationScreen extends ConsumerWidget {
  static const routeName = 'NotificationScreen';

  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationList = ref.watch(
      homeControllerProvider.select((value) => value.notificationList),
    );

    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'แจ้งเตือน',
          style: AppStyle.txtHeader3,
        ),
        elevation: 0.0,
        bgColor: Colors.transparent,
      ),
      bgColor: AppColor.themLineColor,
      bodyBuilder: (context, constrined) {
        return AsyncValueWidget(
          //เรียกใช้ widget
          value: notificationList,
          data: (_notificationList) {
            if (_notificationList == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.all(16).r,
              child: NotificationistWidget(
                notificationList: _notificationList,
              ),
            );
          },
        );
      },
    );
  }
}
