import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';

class PharmacyStoreItemWidget extends ConsumerWidget {
  final PharmacyInfoResponse pharmacyItem;

  const PharmacyStoreItemWidget({
    super.key,
    required this.pharmacyItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _myLatitude = ref.watch(
      storeControllerProvider.select((value) => value.myLatitude),
    );
    final _myLongtitude = ref.watch(
      storeControllerProvider.select((value) => value.myLongtitude),
    );

    double _distance = Geolocator.distanceBetween(
      _myLatitude ?? 0.0,
      _myLongtitude ?? 0.0,
      pharmacyItem.latitude ?? 0.0,
      pharmacyItem.longtitude ?? 0.0,
    );

    double distanceInKilometers = _distance / 1000.0;

    double roundedDistance =
        double.parse((distanceInKilometers).toStringAsFixed(2));

    return GestureDetector(
      onTap: () {
        ref
            .read(storeControllerProvider.notifier)
            .onSelectedPharmacyStore(pharmacyItem);
        Navigator.of(context).pop();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BaseImageView(
            url: '${pharmacyItem.storeImg}',
            width: 120.w,
            height: 110.h,
            fit: BoxFit.cover,
            radius: const BorderRadius.all(
              Radius.circular(150 / 2),
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'ร้าน${pharmacyItem.nameStore}',
                  style: AppStyle.txtBody2,
                ),
                Text(
                  'คะแนนรีวิว ${pharmacyItem.ratingScore != null ? pharmacyItem.ratingScore!.toStringAsFixed(1) : '0.0'} คะแนน',
                  style: AppStyle.txtBody2,
                ),
                Text(
                  'จำนวนคนรีวิว ${pharmacyItem.countReviewer} คน',
                  style: AppStyle.txtBody2,
                ),
                Text(
                  'ระยะทาง $roundedDistance กิโลเมตร',
                  style: AppStyle.txtBody2,
                ),
                Text(
                  'เวลาทำการ ${pharmacyItem.timeOpening} น. - ${pharmacyItem.timeClosing} น.',
                  style: AppStyle.txtBody2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
