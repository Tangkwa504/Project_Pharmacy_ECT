import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/cart/widget/cart_item_widget.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';

class CartListWidget extends ConsumerWidget {
  //เป็น Widget ที่แสดงรายการสินค้าในตะกร้า โดยรับพารามิเตอร์
  final bool isPharmacy;
  final CartResponse myCart;
  final List<MedicineResponse> medicineList;
  final bool isFromOrder;

  const CartListWidget({
    super.key,
    this.isPharmacy = false,
    required this.myCart,
    required this.medicineList,
    this.isFromOrder = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: medicineList.length,
      itemBuilder: (context, index) {
        final medicineItem = medicineList[index];

        return CartItemWidget(
          isPharmacy: isPharmacy,
          myCart: myCart,
          medicineItem: medicineItem,
          isFromOrder: isFromOrder,
        );
      },
      separatorBuilder: (_, __) => SizedBox(
        height: 16.h,
      ),
    );
  }
}
