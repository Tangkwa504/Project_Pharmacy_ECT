import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/page/chat_screen.dart';
import 'package:pharmacy_online/feature/chat/widget/request_consult_list_widget.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';

class RequestConsultScreen extends ConsumerStatefulWidget {
  static const routeName = 'RequestConsultScreen';
  const RequestConsultScreen({super.key});

  @override
  _RequestConsultScreenState createState() => _RequestConsultScreenState();
}

class _RequestConsultScreenState
    extends BaseConsumerState<RequestConsultScreen> {
  @override
  Widget build(BuildContext context) {
    final chatWithPharmacyList = ref.watch(
      storeControllerProvider.select(
        (value) => value.chatWithPharmacyList,
      ),
    );

    final isPharmacy = ref.watch(
      profileControllerProvider.select(
        (value) => value.isPharmacy,
      ),
    );

    return AsyncValueWidget(
      value: chatWithPharmacyList,
      data: (_chatWithPharmacyList) {
        return BaseScaffold(
          appBar: BaseAppBar(
            elevation: 0,
            bgColor: AppColor.themLineColor,
            title: Text(
              'คำขอรับการปรึกษา',
              style: AppStyle.txtHeader3,
            ),
          ),
          bgColor: AppColor.themLineColor,
          bodyBuilder: (context, constrined) {
            if (_chatWithPharmacyList == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.all(16).r,
              child: RequestConsiltListWidget(
                //จะแสดง RequestConsiltListWidget ซึ่งเป็น widget ที่แสดงรายการคำขอการปรึกษาทั้งหมด
                onTap: (chatResponse) {
                  //นำไปยังหน้าแชท ChatScreen เพื่อสนทนากับร้านขายยา
                  Navigator.of(context).pushNamed(
                    ChatScreen.routeName,
                    arguments: ChatArgs(
                      chatWithPharmacyItem: chatResponse,
                      isPharmacy: isPharmacy,
                    ),
                  );
                },
                chatWithPharmacyList: _chatWithPharmacyList,
              ),
            );
          },
        );
      },
    );
  }
}
