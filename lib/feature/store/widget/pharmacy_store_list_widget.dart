import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/store/widget/pharmacy_store_item_widget.dart';

class PharmacyStoreListWidget extends ConsumerWidget {
  final List<PharmacyInfoResponse> pharmacyList;
  const PharmacyStoreListWidget({
    super.key,
    required this.pharmacyList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: pharmacyList.length,
      itemBuilder: (context, index) {
        final pharmacyItem = pharmacyList[index];

        return PharmacyStoreItemWidget(
          pharmacyItem: pharmacyItem,
        );
      },
      separatorBuilder: (_, __) => const BaseDivider(
        top: 8,
        bottom: 8,
        bgColor: Colors.black,
      ),
    );
  }
}
