import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/async_utils.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/widget/order_list_widget.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  static const routeName = 'OrdersScreen';
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends BaseConsumerState<OrdersScreen> {
  Timer? timer; // ตั้งค่าตัวจับเวลา

  @override
  void initState() {
    super.initState();
    // ตั้งค่าตัวจับเวลาให้เรียกฟังก์ชัน onGetAllOrder และ onGetAllMyCart ทุกๆ 200 มิลลิวินาที
    timer = timer =
        Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      if (mounted) {
        final isPharmacy = ref.read(
            profileControllerProvider.select((value) => value.isPharmacy));
        await ref
            .read(orderControllerProvider.notifier)
            .onGetAllOrder(isPharmacy);
        await ref.read(myCartControllerProvider.notifier).onGetAllMyCart(
              OrderStatus.waitingConfirmOrder,
              isPhamarcy: isPharmacy,
            );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // ยกเลิกตัวจับเวลาเมื่อ widget หาย
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));

    // ดูข้อมูลรายการสินค้าในตะกร้าและรายการคำสั่งซื้อ
    final cartList =
        ref.watch(myCartControllerProvider.select((value) => value.cartList));
    final orderList =
        ref.watch(orderControllerProvider.select((value) => value.orderList));

    // รอจนกว่าข้อมูล cartList และ orderList พร้อมใช้งาน
    return AsyncUtils.merge([
      cartList,
      orderList,
    ]).when(
      data: (_) {
        // แยกรายการคำสั่งซื้อตามสถานะ
        final _cartList = cartList.unwrap();
        final _orderList = orderList.unwrap();

        final _orderConfirmOrder = _orderList
            ?.where((val) => val.status == OrderStatus.confirmOrder)
            .toList();

        final _orderWaitingPayment = _orderList
            ?.where((val) => val.status == OrderStatus.waitingPayment)
            .toList();

        final _orderWaitingDelivery = _orderList
            ?.where((val) => val.status == OrderStatus.waitingDelivery)
            .toList();

        final _orderDelivering = _orderList
            ?.where((val) => val.status == OrderStatus.delivering)
            .toList();

        final _orderCompleted = _orderList
            ?.where((val) => val.status == OrderStatus.completed)
            .toList();
        //แสดง tabbar
        return DefaultTabController(
          initialIndex: 0,
          length: isPharmacy ? 6 : 5,
          child: BaseScaffold(
            appBar: AppBar(
              backgroundColor: AppColor.themeWhiteColor,
              title: Text(
                'คำสั่งซื้อ',
                style: AppStyle.txtHeader3,
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: AppColor.themePrimaryColor,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'รอยืนยันออเดอร์',
                      softWrap: false,
                      style: AppStyle.txtBody2,
                    ),
                  ),
                  if (isPharmacy) ...[
                    Tab(
                      child: Text(
                        'ยืนยันออเดอร์',
                        softWrap: false,
                        style: AppStyle.txtBody2,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'รอการชำระ',
                        softWrap: false,
                        style: AppStyle.txtBody2,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'ดำเนินการส่ง',
                        softWrap: false,
                        style: AppStyle.txtBody2,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'รอยืนยันจัดส่ง',
                        softWrap: false,
                        style: AppStyle.txtBody2,
                      ),
                    ),
                  ],
                  if (!isPharmacy) ...[
                    Tab(
                      child: Text(
                        'ที่ต้องชำระ',
                        softWrap: false,
                        style: AppStyle.txtBody2,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'ที่ต้องจัดส่ง',
                        softWrap: false,
                        style: AppStyle.txtBody2,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'ที่ต้องได้รับ',
                        softWrap: false,
                        style: AppStyle.txtBody2,
                      ),
                    ),
                  ],
                  Tab(
                    child: Text(
                      'สำเร็จ',
                      softWrap: false,
                      style: AppStyle.txtBody2,
                    ),
                  ),
                ],
              ),
            ),
            bodyBuilder: (context, constrined) {
              return TabBarView(
                children: <Widget>[
                  OrderListWidget(
                    cartList: _cartList,
                  ),
                  if (isPharmacy) ...[
                    OrderListWidget(
                      orderList: _orderConfirmOrder,
                    ),
                  ],
                  OrderListWidget(
                    orderList: _orderWaitingPayment,
                  ),
                  OrderListWidget(
                    orderList: _orderWaitingDelivery,
                  ),
                  OrderListWidget(
                    orderList: _orderDelivering,
                  ),
                  OrderListWidget(
                    orderList: _orderCompleted,
                  ),
                ],
              );
            },
          ),
        );
      },
      error: (e, __) => const SizedBox.shrink(),
      loading: () => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
