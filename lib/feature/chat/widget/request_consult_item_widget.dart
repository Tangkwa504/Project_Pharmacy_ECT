import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/controller/chat_controller.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

class RequestConsultItemWidget extends ConsumerStatefulWidget {
  final ChatWithPharmacyResponse chatWithPharmacyItem;
  final Function(ChatWithPharmacyResponse chatResponse) onTap;

  const RequestConsultItemWidget({
    super.key,
    required this.chatWithPharmacyItem,
    required this.onTap,
  });

  @override
  _RequestConsultItemWidgetState createState() =>
      _RequestConsultItemWidgetState();
}

class _RequestConsultItemWidgetState
    extends BaseConsumerState<RequestConsultItemWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      //ตรวจสอบเงื่อนไข จะยกเลิกคำขอหลังจากผ่านไปเวลา 5 นาทีแล้วไม่มีการตอบรับ
      final itemTime = widget.chatWithPharmacyItem.createAt;
      final currentTime = DateTime.now();
      final isMoreThan5Mins = currentTime.difference(itemTime!).inMinutes >= 5;

      if (isMoreThan5Mins) {
        //ทำการยกเลิกคำขอและแจ้งเตือนผู้ใช้
        final result = await ref
            .read(storeControllerProvider.notifier)
            .onApproveChatWithPharmacy(
              false,
              '${widget.chatWithPharmacyItem.id}',
            );

        if (result) {
          await ref.read(homeControllerProvider.notifier).onPostNotification(
                'คำขอรับการปรึกษาของคุณถูกยกเลิก\nเนื่องจากร้านขายยาไม่ได้ตอบรับในระยะเวลาที่กำหนด',
                'cancelChat',
                '${widget.chatWithPharmacyItem.uid}',
              );
          await ref.read(homeControllerProvider.notifier).onPostNotification(
                'มีคำขอรับการปรึกษาถูกยกเลิก\nเนื่องจากคุณไม่ได้ตอบรับในระยะเวลาที่กำหนด',
                'cancelChat',
                '${widget.chatWithPharmacyItem.pharmacyId}',
              );
          await ref
              .read(storeControllerProvider.notifier)
              .onGetGetRequestChatWithPharmacy();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //โค้ดที่ใช้สำหรับสร้าง UI ของ RequestConsultItemWidget
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );

    final pharmacyStore = ref.watch(
      profileControllerProvider.select((value) => value.pharmacyStore),
    );

    return Container(
      padding: const EdgeInsets.all(16).r,
      decoration: BoxDecoration(
        color: AppColor.themeWhiteColor,
        borderRadius: BorderRadius.all(
          const Radius.circular(16).r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //ภาพโปรไฟล์ของผู้ใช้
          BaseImageView(
            url: '${widget.chatWithPharmacyItem.profileImg}',
            width: 80.w,
            height: 80.h,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(16).r,
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //ชื่อผู้ใช้ที่ส่งคำขอ
                Text(
                  '${widget.chatWithPharmacyItem.fullName}',
                  style: AppStyle.txtHeader3,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        //ปุ่ม "ตอบรับ"
                        onTap: () async {
                          //ตอบรับคำขอ
                          final result = await ref
                              .read(storeControllerProvider.notifier)
                              .onApproveChatWithPharmacy(
                                true,
                                '${widget.chatWithPharmacyItem.id}',
                              );

                          if (result) {
                            await ref
                                .read(homeControllerProvider.notifier)
                                .onPostNotification(
                                  'ร้าน${pharmacyStore?.nameStore} ตอบรับคำขอแล้ว\nกรุณาไปที่หน้าแชทเพื่อทำการปรึกษา',
                                  'approveChat',
                                  '${widget.chatWithPharmacyItem.uid}',
                                );

                            await ref
                                .read(storeControllerProvider.notifier)
                                .onGetGetRequestChatWithPharmacy();

                            final pharmacyId = ref
                                .read(baseSharePreferenceProvider)
                                .getString(BaseSharePreferenceKey.userId);

                            final result = await ref
                                .read(chatControllerProvider.notifier)
                                .onGetChatDetail('$pharmacyId',
                                    '${widget.chatWithPharmacyItem.uid}');
                            final id = result.id;
                            if (id != null && id.isNotEmpty) {
                              widget.onTap(result);

                              return;
                            }
                          }
                        },
                        text: 'ตอบรับ',
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: BaseButton(
                        //ปุ่ม "ปฏิเสธ"
                        onTap: () async {
                          //ปฏิเสธคำขอ
                          final result = await ref
                              .read(storeControllerProvider.notifier)
                              .onApproveChatWithPharmacy(
                                false,
                                '${widget.chatWithPharmacyItem.id}',
                              );

                          if (result) {
                            await ref
                                .read(homeControllerProvider.notifier)
                                .onPostNotification(
                                  //'${userInfo?.fullName} ยกเลิกคำร้องขอของคุณ',
                                  'ร้าน${pharmacyStore?.nameStore}ปฏิเสธคำขอปรึกษาของคุณ',
                                  'cancelChat',
                                  '${widget.chatWithPharmacyItem.uid}',
                                );

                            await ref
                                .read(storeControllerProvider.notifier)
                                .onGetGetRequestChatWithPharmacy();
                          }
                        },
                        buttonType: ButtonType.danger,
                        text: 'ปฎิเสธ',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
