import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/feature/home/model/response/notification_response.dart';
import 'package:pharmacy_online/feature/home/widget/notificaton_item_widget.dart';

class NotificationistWidget extends ConsumerWidget {
  final List<NotificationResponse> notificationList;

  const NotificationistWidget({
    super.key,
    required this.notificationList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(    //ListView.separated จะเป็นคำสั่งที่เอาไว้แสดงเป็นกล่องๆ โดนอ่านค่าจาก index ในที่นี้คือกล่องการแจ้งเตือน
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: notificationList.length,
      itemBuilder: (context, index) {
        final notificationItem = notificationList[index];

        return NotificationItemWidget(
          notificationItem: notificationItem,
        );
      },
      separatorBuilder: (_, __) => SizedBox(
        height: 16.h,
      ),
    );
  }
}
