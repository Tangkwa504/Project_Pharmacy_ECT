import 'dart:async'; // สำหรับจัดการกับการทำงานแบบ asynchronous

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; //สำหรับจัดการขนาดหน้าจอ
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/cart/page/my_cart_screen.dart';
import 'package:pharmacy_online/feature/cart/page/order_summary_screen.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/extension/order_status_extension.dart';
import 'package:pharmacy_online/feature/order/model/response/order_response.dart';
import 'package:pharmacy_online/feature/order/page/order_detail_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

// คลาสสำหรับสร้าง widget แสดงข้อมูลรายการคำสั่งซื้อ
class OrderItemWidget extends ConsumerStatefulWidget {
  // รับข้อมูลคำสั่งซื้อจาก cartItem หรือ orderItem
  final CartResponse? cartItem;
  final OrderResponse? orderItem;

  const OrderItemWidget({
    super.key,
    this.cartItem,
    this.orderItem,
  });

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends BaseConsumerState<OrderItemWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      // ตรวจสอบสถานะคำสั่งซื้อทุก 500 มิลลิวินาที
      final cartItem = widget.cartItem;
      final orderItem = widget.orderItem;

      final itemTime = orderItem?.createAt ?? cartItem?.createAt;
      final billStatus = orderItem?.status ?? cartItem?.status;

      final uid = cartItem?.uid ?? orderItem?.uid;
      final pharmacyId = cartItem?.pharmacyId ?? orderItem?.pharmacyId;
      final fullName = cartItem?.fullName ?? orderItem?.myCart?.fullName;

      final id = orderItem?.id ?? cartItem?.id;
      final cartId = orderItem?.cartId ?? cartItem?.id;

      final isPayment = billStatus == OrderStatus.waitingPayment;

      final currentTime = DateTime.now();
      final isMoreThan4Hours = currentTime.difference(itemTime!).inHours > 4;
      final isPharmacy = ref
          .watch(profileControllerProvider.select((value) => value.isPharmacy));

      // ถ้าเวลาเกิน 4 ชั่วโมง และสถานะเป็นรอการชำระเงิน
      if (isMoreThan4Hours && isPayment) {
        final result = await ref
            .read(orderControllerProvider.notifier)
            .onDeleteOrder('$id', '$cartId');

        if (result) {
          // แจ้งโนติถึงผู้ใช้
          await ref.read(homeControllerProvider.notifier).onPostNotification(
                'คำสั่งซื้อถูกยกเลิกเนื่องจากไม่ได้ชำระเงินในระยะเวลาที่กำหนด',
                'cancelChat',
                '$uid',
              );
        }
      }

      // ถ้าสถานะเป็นกำลังจัดส่ง
      if (billStatus == OrderStatus.delivering) {
        final updateAt = orderItem?.updateAt ?? cartItem?.updateAt;
        final isMoreThan4Hours = currentTime.difference(updateAt!).inHours > 4;
        if (isMoreThan4Hours) {
          final result =
              await ref.read(orderControllerProvider.notifier).onUpdateOrder(
                    '$id',
                    '$cartId',
                    status: OrderStatus.completed,
                  );
          if (result) {
            // อัพเดทรายการคำสั่งทั้งหมด
            await ref.read(orderControllerProvider.notifier).onGetAllOrder(
                  isPharmacy,
                );

            // ดึงข้อมูลคำสั่งซื้อที่มี ID ตรงกับคำสั่งซื้อปัจจุบัน
            await ref.read(orderControllerProvider.notifier).onGetOrder(
                  '$uid',
                  '$pharmacyId',
                  OrderStatus.completed,
                  orderId: id,
                );

            await ref.read(homeControllerProvider.notifier).onPostNotification(
                  '$fullName ยืนยันการจัดส่งสำเร็จ',
                  OrderStatus.completed.name,
                  '$pharmacyId',
                );

            // แจ้งโนติถึงผู้ใช้
            await ref.read(homeControllerProvider.notifier).onPostNotification(
                  'ยืนยันการจัดส่งสำเร็จ',
                  OrderStatus.completed.name,
                  '$uid',
                );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ยกเลิก Timer เมื่อ widget ถูก destroy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));
    final cartItem = widget.cartItem;
    final orderItem = widget.orderItem;

    final billNumber = cartItem?.cartNumber ?? orderItem?.orderNumber;
    final cartId = cartItem?.id ?? orderItem?.cartId;
    final orderId = orderItem?.id;

    final billStatus = cartItem?.status ?? orderItem?.status;
    final billName = isPharmacy
        ? (cartItem?.fullName ?? orderItem?.myCart?.fullName)
        : (cartItem?.nameStore ?? orderItem?.myCart?.nameStore);

    final uid = cartItem?.uid ?? orderItem?.uid;
    final pharmacyId = cartItem?.pharmacyId ?? orderItem?.pharmacyId;

    String? billStatusLabel;

    if (isPharmacy) {
      billStatusLabel = billStatus?.statusLabelPharmacy;
    } else {
      billStatusLabel = billStatus?.statusLabelUser;
    }

    final statusColor = billStatus?.statusLabelColor;

    return GestureDetector(
      onTap: () async {
        if (billStatus == OrderStatus.waitingConfirmOrder) {
          // ดึงข้อมูลรายการตะกร้าสินค้าที่รอการยืนยัน
          await ref.read(myCartControllerProvider.notifier).onGetCart(
                '$uid',
                '$pharmacyId',
                OrderStatus.waitingConfirmOrder,
                cartId: cartId,
              );

          // นำทางไปยังหน้าจอรายการตะกร้าสินค้า
          Navigator.of(context).pushNamed(
            MyCartScreen.routeName,
            arguments: MyCartArgs(
              isPharmacy: isPharmacy,
              isFromOrder: true,
            ),
          );

          return;
        }

        // หากสถานะเป็นรอการยืนยัน
        if (billStatus == OrderStatus.confirmOrder) {
          // ดึงข้อมูลรายการตะกร้าสินค้าที่ยืนยันแล้ว
          await ref.read(myCartControllerProvider.notifier).onGetCart(
                '$uid',
                '$pharmacyId',
                OrderStatus.confirmOrder,
                cartId: cartId,
              );

          // ดึงข้อมูลคำสั่งซื้อที่มี ID ตรงกับคำสั่งซื้อปัจจุบัน
          await ref.read(orderControllerProvider.notifier).onGetOrder(
                '$uid',
                '$pharmacyId',
                OrderStatus.confirmOrder,
                orderId: orderId,
              );

          // นำทางไปยังหน้าจอสรุปคำสั่งซื้อ
          Navigator.of(context).pushNamed(
            OrderSummaryScreen.routeName,
          );

          return;
        }

        // ดึงข้อมูลคำสั่งซื้อที่มี ID ตรงกับคำสั่งซื้อปัจจุบัน
        await ref.read(orderControllerProvider.notifier).onGetOrder(
              '$uid',
              '$pharmacyId',
              billStatus!,
              orderId: orderId,
            );

        // นำทางไปยังหน้าจอรายละเอียดคำสั่งซื้อ
        Navigator.of(context).pushNamed(OrderDetailScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(16).r,
        child: Row(
          children: [
            Assets.icons.icOrder.svg(),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, //ชิดบน
                crossAxisAlignment: CrossAxisAlignment.start, //ชิดซ้าย
                children: [
                  if (!isPharmacy) ...[
                    Text(
                      'ร้าน$billName',
                      style: AppStyle.txtBody2
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                  if (isPharmacy) ...[
                    Text(
                      '$billName',
                      style: AppStyle.txtBody2
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'เลขที่ออเดอร์: ',
                        style: AppStyle.txtBody2,
                      ),
                      Text(
                        '$billNumber',
                        style: AppStyle.txtBody2.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'สถานะ : ',
                        style: AppStyle.txtBody2,
                      ),
                      Text(
                        '$billStatusLabel',
                        style: AppStyle.txtBody2.copyWith(
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
