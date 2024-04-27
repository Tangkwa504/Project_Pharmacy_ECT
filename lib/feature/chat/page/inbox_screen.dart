import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/controller/chat_controller.dart';
import 'package:pharmacy_online/feature/chat/widget/inbox_list_widget.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';

class InboxScreen extends ConsumerStatefulWidget {
  static const routeName = 'InboxScreen';

  const InboxScreen({super.key});

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends BaseConsumerState<InboxScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    //ตั้งค่า Timer เพื่อเรียกใช้งานข้อมูล Inbox ทุก 0.5 วินาที
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      final isPharmacy = ref
          .watch(profileControllerProvider.select((value) => value.isPharmacy));

      if (isPharmacy) {
        ref.read(chatControllerProvider.notifier).onGetHistoryOfChatPharmacy();
      } else {
        ref.read(chatControllerProvider.notifier).onGetHistoryOfChatUser();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatWithPharmacyList = ref.watch(
      chatControllerProvider.select((value) => value.chatWithPharmacyList),
    );

    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        bgColor: AppColor.themLineColor,
        title: Text(
          'กล่องข้อความ',
          style: AppStyle.txtHeader3,
        ),
        hideBackButton: true,
      ),
      bgColor: AppColor.themLineColor,
      bodyBuilder: (context, constrined) {
        return AsyncValueWidget(
          value: chatWithPharmacyList,
          data: (_chatWithPharmacyList) {
            if (_chatWithPharmacyList == null) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.all(16).r,
              child:
                  InboxListWidget(chatWithPharmacyList: _chatWithPharmacyList),
            );
          },
        );
      },
    );
  }
}
