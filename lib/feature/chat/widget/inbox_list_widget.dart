import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/widget/inbox_item_widget.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

//วิดเจ็ตที่ใช้แสดงรายการของ inbox items
class InboxListWidget extends ConsumerStatefulWidget {
  final List<ChatWithPharmacyResponse> chatWithPharmacyList;

  const InboxListWidget({
    super.key,
    required this.chatWithPharmacyList,
  });

  @override
  _InboxListWidgetState createState() => _InboxListWidgetState();
}

class _InboxListWidgetState extends BaseConsumerState<InboxListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.chatWithPharmacyList.length,
      itemBuilder: (context, index) {
        final chatWithPharmacyItem = widget.chatWithPharmacyList[index];
        //ใช้ InboxItemWidget เพื่อแสดงข้อมูลละเอียดเกี่ยวกับแต่ละ inbox item
        return InboxItemWidget(chatWithPharmacyItem: chatWithPharmacyItem);
      },
      separatorBuilder: (_, __) => SizedBox(
        height: 16.h,
      ),
    );
  }
}
