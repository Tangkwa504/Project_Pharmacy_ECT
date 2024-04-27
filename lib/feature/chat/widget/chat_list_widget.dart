import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/widget/chat_item_widget.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
// import 'package:pharmacy_online/utils/util/date_format.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/utils/util/date_format.dart';

class ChatListWidget extends ConsumerStatefulWidget {
  final List<ChatWithPharmacyResponse> messageList;

  const ChatListWidget({super.key, required this.messageList});

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends BaseConsumerState<ChatListWidget> {
  final ScrollController _scrollController = ScrollController();
  bool isFirstRender = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    //ตั้งค่า ScrollController และเริ่มต้นการทำงานของ Timer
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      // final uid = ref
      //     .read(baseSharePreferenceProvider)
      //     .getString(BaseSharePreferenceKey.userId);
      // final isLastMessageIsMe = widget.messageList.last.uid == uid;

      if (mounted) {
        if (isFirstRender) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

          await Future.delayed(
            const Duration(milliseconds: 200),
          );
          isFirstRender = false;
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    //ยกเลิก Timer เมื่อ Widget หายไป
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageList = widget.messageList;

    return ListView.separated(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: messageList.length,
      itemBuilder: (context, index) {
        final createAt = messageList[index].createAt;
        final messageItem = messageList[index];
        //ดึงข้อมูลเวลาสร้างและเวลาปรับปรุงของข้อความ
        final updateAt = messageList[index].updateAt;
        String? dateTime;

        //แปลงรูปแบบวันที่และเวลา
        if (createAt != null || updateAt != null) {
          final convertDate = ref
              .read(baseDateFormatterProvider)
              .convertStringToDateTime('${createAt ?? updateAt}');

          dateTime = ref
              .read(baseDateFormatterProvider)
              .formatDateToDisplayDate(convertDate);
        }

        // ตรวจสอบว่าข้อมูลที่ต้องการใช้มีค่า null หรือไม่
        if (createAt != null) {
          final createAtDate =
              DateTime(createAt.year, createAt.month, createAt.day);

          if (index == 0) {
            return Column(
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  '$dateTime',
                  style: AppStyle.txtCaption,
                ),
                SizedBox(
                  height: 15.h,
                ),
                ChatItemWidget(messageItem: messageItem),
              ],
            );
          }

          // ตรวจสอบว่ายังไม่ถึงตำแหน่งสุดท้ายของลิสต์
          if (index + 1 < messageList.length) {
            final nextCreateAt = messageList[index - 1].createAt;
            if (nextCreateAt != null) {
              final nextCreateAtDate = DateTime(
                  nextCreateAt.year, nextCreateAt.month, nextCreateAt.day);

              // ตรวจสอบว่าถ้าวันถัดไปไม่เท่ากับวันปัจจุบัน
              if (nextCreateAtDate.day != createAtDate.day) {
                return Column(
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      '$dateTime',
                      style: AppStyle.txtCaption,
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    ChatItemWidget(messageItem: messageItem),
                  ],
                );
              } else {
                // ถ้าวันซ้ำกับวันปัจจุบัน
                return ChatItemWidget(messageItem: messageItem);
              }
            }
            return ChatItemWidget(messageItem: messageItem);
          }
          return ChatItemWidget(messageItem: messageItem);
        }

        // ในกรณีที่ข้อมูลมีค่า null หรือไม่ตรงตามเงื่อนไข ให้ส่งคืน null หรือ Widget ที่เหมาะสม
        return const SizedBox();
      },
      separatorBuilder: (_, __) => SizedBox(
        height: 16.h,
      ),
    );
  }
}
