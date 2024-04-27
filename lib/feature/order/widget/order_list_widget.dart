import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/order/model/response/order_response.dart';
import 'package:pharmacy_online/feature/order/widget/order_item_widget.dart';

// คลาสสำหรับสร้าง ListView แสดงรายการคำสั่งซื้อ
class OrderListWidget extends ConsumerWidget {
  // รับข้อมูลรายการคำสั่งซื้อจาก cartList หรือ orderList
  final List<CartResponse>? cartList;
  final List<OrderResponse>? orderList;

  const OrderListWidget({super.key, this.cartList, this.orderList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // สร้าง ListView แสดงรายการคำสั่งซื้อ
    return ListView.separated(
      // ตั้งค่าการเลื่อนของ ListView ให้อยู่ภายในขอบเขตที่กำหนด
      physics: const ClampingScrollPhysics(),
      // ปรับขนาดตามเนื้อหาภายใน
      shrinkWrap: true,
      // จำนวนรายการคำสั่งซื้อ กำหนดตาม data ที่มี
      itemCount: cartList?.length ?? orderList?.length ?? 0,
      // สร้างแต่ละรายการคำสั่งซื้อ
      itemBuilder: (context, index) {
        // ดึงข้อมูลคำสั่งซื้อจาก cartList หรือ orderList ตามข้อมูลที่มี
        CartResponse? cartItem;
        OrderResponse? orderItem;

        if (cartList != null) {
          cartItem = cartList?[index];
        }

        if (orderList != null) {
          orderItem = orderList?[index];
        }

        return OrderItemWidget(
          // ส่งข้อมูลคำสั่งซื้อไปให้ OrderItemWidget สร้าง UI
          cartItem: cartList != null ? cartItem : null,
          orderItem: orderList != null ? orderItem : null,
        );
      },
      // สร้างเส้นแบ่งระหว่างแต่ละรายการคำสั่งซื้อ
      separatorBuilder: (_, __) => const BaseDivider(
        bgColor: AppColor.themeGrayLight,
      ),
    );
  }
}
