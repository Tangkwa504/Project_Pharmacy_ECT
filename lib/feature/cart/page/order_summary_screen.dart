import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/cart/enum/field_address_delivery_enum.dart';
import 'package:pharmacy_online/feature/dashboard/page/dashboard_screen.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
import 'package:pharmacy_online/feature/order/enum/field_order_summary_enum.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/page/order_detail_screen.dart';
// import 'package:pharmacy_online/feature/order/page/order_detail_screen.dart';
import 'package:pharmacy_online/feature/order/widget/card_content_widget.dart';
import 'package:pharmacy_online/feature/order/widget/medicine_list_widget.dart';
import 'package:pharmacy_online/feature/order/widget/row_content_widget.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/utils/util/date_format.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class OrderSummaryScreen extends ConsumerStatefulWidget {
  static const routeName = 'OrderSummaryScreen';

  const OrderSummaryScreen({super.key});

  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends BaseConsumerState<OrderSummaryScreen> {
  final formKey = GlobalKey<BaseFormState>();
  final List<Map<String, String>> _howToUse = [];

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));

    final myCart =
        ref.watch(myCartControllerProvider.select((value) => value.myCart));
    final orderDetail =
        ref.watch(orderControllerProvider.select((value) => value.orderDetail));

    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          isPharmacy ? 'คำสั่งซื้อ' : 'สรุปคำสั่งซื้อ',
          style: AppStyle.txtHeader3,
        ),
        actions: [
          if (isPharmacy) ...[
            GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (_) {
                    return BaseDialog(
                      message: 'ต้องการยกเลิกคำสั่งซื้อ?',
                      hasCancel: true,
                      onClick: () async {
                        final _orderDetail = orderDetail.value;
                        final result = await ref
                            .read(orderControllerProvider.notifier)
                            .onDeleteOrder(
                              '${_orderDetail?.id}',
                              '${_orderDetail?.cartId}',
                            );

                        if (result) {
                          await ref
                              .read(orderControllerProvider.notifier)
                              .onGetAllOrder(true);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16).r,
                child: Text(
                  'ยกเลิกคำสั่งซื้อ',
                  style: AppStyle.txtBody2,
                ),
              ),
            ),
          ],
        ],
        bgColor: AppColor.themLineColor,
      ),
      bgColor: AppColor.themLineColor,
      bodyBuilder: (context, constrained) {
        final baseFormData = ref.watch(
          myCartControllerProvider.select(
            (value) => value.baseFormData,
          ),
        );

        final fullName = baseFormData?.getValue(FieldAddressDelivery.fullName);
        final phone = baseFormData?.getValue(FieldAddressDelivery.phone);
        final address = baseFormData?.getValue(FieldAddressDelivery.address);
        final district = baseFormData?.getValue(FieldAddressDelivery.district);
        final subDistrict =
            baseFormData?.getValue(FieldAddressDelivery.subDistrict);
        final province = baseFormData?.getValue(FieldAddressDelivery.province);
        final post = baseFormData?.getValue(FieldAddressDelivery.post);

        return AsyncValueWidget(
          value: myCart,
          data: (_myCart) {
            final medicineList = _myCart?.medicineList;
            final userInfo = ref.watch(
                profileControllerProvider.select((value) => value.userInfo));

            final price = medicineList?.fold(0.0, (previous, val) {
                  final totalPrice =
                      (val.price ?? 0.0) * ((val.quantity ?? 0.0) * 1.0);
                  return totalPrice + previous;
                }) ??
                0.0;

            final priceTotal = price;

            final nameStore = _myCart?.nameStore;

            final _orderDetail = orderDetail.value;
            final orderNumber = _orderDetail?.orderNumber;
            final convertCreateAt = ref
                .read(baseDateFormatterProvider)
                .convertStringToDateTime(
                    '${_orderDetail?.createAt ?? _myCart?.createAt}');
            final createAt = ref
                .read(baseDateFormatterProvider)
                .formatDateWithFreeStyleFormat('dd/MM/yyyy', convertCreateAt);
            final createAtTime = ref
                .read(baseDateFormatterProvider)
                .formatDateWithFreeStyleFormat('HH:mm', convertCreateAt);

            final cartDetail = _orderDetail?.myCart;
            final cartSummaryPrice = cartDetail?.sumamryPrice;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16).r,
                child: BaseForm(
                  key: formKey,
                  onChanged:
                      ref.read(orderControllerProvider.notifier).onChanged,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (isPharmacy) ...[
                        CardContentWidget(
                          content: Column(
                            children: [
                              RowContentWidget(
                                header: 'ร้าน:',
                                content: '$nameStore',
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              RowContentWidget(
                                header: 'เลขที่บิล:',
                                content: '$orderNumber',
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              RowContentWidget(
                                header: 'วันที่:',
                                content: createAt,
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              RowContentWidget(
                                header: 'เวลา:',
                                content: createAtTime,
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              RowContentWidget(
                                header: 'ราคารวมทั้งหมด:',
                                content: '$cartSummaryPrice',
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (!isPharmacy) ...[
                        CardContentWidget(
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$fullName',
                                style: AppStyle.txtBody,
                              ),
                              Text(
                                '$phone',
                                style: AppStyle.txtBody,
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                '$address $district $subDistrict $province $post',
                                style: AppStyle.txtCaption.copyWith(
                                  color: AppColor.themeGrayLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(
                        height: 16.h,
                      ),
                      if (isPharmacy) ...[
                        BaseTextField(
                          fieldKey: FieldOrderSummary.diagnose,
                          label: 'วินิจฉัยอาการป่วย',
                          validator: Validators.combine(
                            [
                              Validators.withMessage(
                                "กรุณาระบุคำวินิจฉัยอาการป่วย",
                                Validators.isEmpty,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        const BaseTextField(
                          fieldKey: FieldOrderSummary.moreDetail,
                          label: 'รายละเอียดเพิ่มเติม',
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          'รายละเอียดยา',
                          style: AppStyle.txtHeader3,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                      ],
                      if (medicineList != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16).r,
                          color: AppColor.themeWhiteColor,
                          child: MedicineListWidget(
                            hasTextForm: isPharmacy,
                            medicineList: medicineList,
                            isOrder: true,
                            onChange: (val) {
                              setState(() {
                                if (_howToUse.isNotEmpty) {
                                  _howToUse.removeWhere(
                                    (element) =>
                                        element.entries.first.key ==
                                        val.entries.first.key,
                                  );
                                }
                                _howToUse.insert(0, val);
                              });
                            },
                          ),
                        ),
                      ],
                      if (!isPharmacy) ...[
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          'รายละเอียด',
                          style: AppStyle.txtBody,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        RowContentWidget(
                          header: 'ราคารวม',
                          content: '$priceTotal บาท',
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        const RowContentWidget(
                          header: 'ค่าจัดส่ง',
                          content: '50 บาท',
                        ),
                        // const RowContentWidget(
                        //   header: 'Vat7%',
                        //   content: '1.89 บาท',
                        // ),
                        SizedBox(
                          height: 8.h,
                        ),
                        RowContentWidget(
                          header: 'ราคารวมทั้งหมด',
                          content: '${priceTotal + 50} บาท',
                          isBold: true,
                        ),
                      ],
                      SizedBox(
                        height: 16.h,
                      ),
                      BaseButton(
                        onTap: () async {
                          if (isPharmacy) {
                            formKey.currentState?.save(onSave: (_) async {
                              final hasEmpty = _howToUse.isEmpty ||
                                  _howToUse.any(
                                    (element) =>
                                        element.entries.first.value.isEmpty ||
                                        _howToUse.length !=
                                            medicineList?.length,
                                  );

                              if (hasEmpty) {
                                Fluttertoast.showToast(
                                  msg: "กรุณาระบุวิธีการใช้/คำแนะนำให้ครบ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                return;
                              }

                              final result = await ref
                                  .read(orderControllerProvider.notifier)
                                  .onUpdateOrder(
                                    '${_orderDetail?.id}',
                                    '${_myCart?.id}',
                                    howToUse: _howToUse,
                                    status: OrderStatus.waitingPayment,
                                  );
                              if (result) {
                                await ref
                                    .read(homeControllerProvider.notifier)
                                    .onPostNotification(
                                      'กรุณาชำระเงิน ร้าน${_myCart?.nameStore}',
                                      OrderStatus.waitingPayment.name,
                                      '${_orderDetail?.uid}',
                                    );
                                await ref
                                    .read(orderControllerProvider.notifier)
                                    .onGetOrder(
                                      '${_myCart?.uid}',
                                      '${_myCart?.pharmacyId}',
                                      OrderStatus.waitingPayment,
                                    );

                                await ref
                                    .read(orderControllerProvider.notifier)
                                    .onGetAllOrder(
                                      isPharmacy,
                                    );

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  OrderDetailScreen.routeName,
                                  (route) =>
                                      route.settings.name ==
                                      DashboardScreen.routeName,
                                );
                              }
                            });
                          } else {
                            await ref
                                .read(myCartControllerProvider.notifier)
                                .onUpdateCart(
                                  '${_myCart?.id}',
                                  '0',
                                  '50',
                                  '$priceTotal',
                                  '${priceTotal + 50}',
                                  OrderStatus.confirmOrder,
                                );

                            final result = await ref
                                .read(orderControllerProvider.notifier)
                                .onAddOrder(
                                  '${_myCart?.pharmacyId}',
                                  '${_myCart?.uid}',
                                  '${_myCart?.pharmacyId}',
                                  '${_myCart?.id}',
                                );

                            if (result) {
                              await ref
                                  .read(homeControllerProvider.notifier)
                                  .onPostNotification(
                                    '${'${userInfo?.fullName}'} ยืนยันออเดอร์แล้ว',
                                    OrderStatus.confirmOrder.name,
                                    '${_myCart?.pharmacyId}',
                                  );

                              await ref
                                  .read(orderControllerProvider.notifier)
                                  .onGetOrder(
                                    '${_myCart?.uid}',
                                    '${_myCart?.pharmacyId}',
                                    OrderStatus.confirmOrder,
                                  );

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                DashboardScreen.routeName,
                                (route) => false,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: "เพิ่มออเดอร์ไม่สำเร็จ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          }
                        },
                        text: isPharmacy ? 'ถัดไป' : 'ยืนยัน',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
