import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/admin/widget/pharmacy_item_widget.dart';

class PharmacyListWidget extends ConsumerWidget {
  final List<PharmacyInfoResponse> pharmacyList;

  const PharmacyListWidget({
    super.key,
    required this.pharmacyList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // สร้าง Widget รายการร้านเภสัชกรที่ใช้ใน ListView.separated
    return ListView.separated(
      shrinkWrap: true, // ทำให้ ListView ทำงานในรูปแบบ shrinkWrap
      itemCount: pharmacyList.length,
      itemBuilder: (context, index) {
        // ดึงข้อมูลร้านเภสัชกรตามลำดับ index
        final pharmacyItem = pharmacyList[index];
        // สร้างและคืนค่า Widget ของแต่ละร้านเภสัชกร
        return PharmacyItemWidget(pharmacyItem: pharmacyItem);
      },
      separatorBuilder: (_, __) => const BaseDivider(
        top: 8,
        bottom: 8,
        bgColor: AppColor.themeGrayLight,
      ),
    );
  }
}
