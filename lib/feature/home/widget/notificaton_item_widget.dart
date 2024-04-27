import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/home/model/response/notification_response.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class NotificationItemWidget extends ConsumerStatefulWidget {
  final NotificationResponse notificationItem;

  const NotificationItemWidget({
    super.key,
    required this.notificationItem,
  });

  @override
  _NotificationItemWidgetState createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState
    extends BaseConsumerState<NotificationItemWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref
          .read(homeControllerProvider.notifier)
          .onUpdateNotificationUsecase('${widget.notificationItem.id}');

      await ref.read(homeControllerProvider.notifier).onGetNotification();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.themeWhiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          statusIcon('${widget.notificationItem.status}'),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Text(
              "${widget.notificationItem.message}",
              style: AppStyle.txtBody2,
            ),
          ),
        ],
      ),
    );
  }

  //ดึงไอค่อนมาใช้
  Widget statusIcon(String status) {
    switch (status) {
      case 'approveChat':
        return Assets.icons.icSuccessStatus.svg();
      case 'cancelChat':
        return Assets.icons.icWarning.svg();
      case 'warningChat':
        return Assets.icons.icWarning.svg();
      case 'waitingPayment':
        return Assets.icons.icWarning.svg();

      default:
        return Assets.icons.icSuccessStatus.svg();
    }
  }
}
