import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';

class EvidenceBankTransferScreen extends ConsumerWidget {
  // ชื่อของ route สำหรับการนำทางไปยังหน้าจอนี้
  static const routeName = 'EvidenceBankTransferScreen';

  const EvidenceBankTransferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ดึงข้อมูลรายละเอียดการสั่งซื้อจาก orderControllerProvider
    final orderDetail = ref
        .watch(orderControllerProvider.select((value) => value.orderDetail))
        .value;
    final bankTransferSlip = orderDetail?.bankTransferSlip;
    final bankTransferDate = orderDetail?.bankTransferDate;
    final bankTotalPriceSlip = orderDetail?.bankTotalPriceSlip;

    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        title: Text(
          'การชำระเงิน',
          style: AppStyle.txtHeader3,
        ),
        elevation: 0,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Container(
            // กำหนดความกว้างให้เต็มหน้าจอ
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // แสดงรูปภาพสลิปการโอนเงิน
                InteractiveViewer(
                  child: BaseImageView(
                    url: '$bankTransferSlip',
                    width: 350,
                    //height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'หลักฐานการชำระเงิน',
                  style: AppStyle.txtHeader3,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'วันที่โอน $bankTransferDate น.',
                  style: AppStyle.txtBody2,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'จำนวนเงิน $bankTotalPriceSlip บาท',
                  style: AppStyle.txtBody2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
