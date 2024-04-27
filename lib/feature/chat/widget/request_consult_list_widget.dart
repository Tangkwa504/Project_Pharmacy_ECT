import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/feature/chat/widget/request_consult_item_widget.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

class RequestConsiltListWidget extends ConsumerWidget {
  final List<ChatWithPharmacyResponse> chatWithPharmacyList;
  final Function(ChatWithPharmacyResponse chatResponse) onTap;
  const RequestConsiltListWidget({
    super.key,
    required this.chatWithPharmacyList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: chatWithPharmacyList.length,
      itemBuilder: (context, index) {
        final chatWithPharmacyItem = chatWithPharmacyList[index];

        return RequestConsultItemWidget(
          onTap: onTap,
          chatWithPharmacyItem: chatWithPharmacyItem,
        );
      },
      separatorBuilder: (_, __) => SizedBox(
        height: 16.h,
      ),
    );
  }
}
