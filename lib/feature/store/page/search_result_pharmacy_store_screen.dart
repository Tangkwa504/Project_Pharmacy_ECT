import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/widget/pharmacy_store_list_widget.dart';

class SearchResultPharmacyStoreScreen extends ConsumerWidget {
  static const routeName = 'SearchResultPharmacyStoreScreen';

  const SearchResultPharmacyStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPharmacyInfoList = ref.watch(storeControllerProvider
        .select((value) => value.searchPharmacyInfoList));

    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'ผลการค้นหา',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: PharmacyStoreListWidget(
              pharmacyList: searchPharmacyInfoList ?? [],
            ),
          ),
        );
      },
    );
  }
}
