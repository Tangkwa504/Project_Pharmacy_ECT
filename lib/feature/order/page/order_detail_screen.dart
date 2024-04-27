import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/page/add_review_screen.dart';
import 'package:pharmacy_online/feature/order/page/evidence_bank_transfer_screen.dart';
import 'package:pharmacy_online/feature/order/page/evidence_transportation_screen.dart';
import 'package:pharmacy_online/feature/order/page/upload_bank_transfer_screen.dart';
import 'package:pharmacy_online/feature/order/page/upload_transportation_screen.dart';
import 'package:pharmacy_online/feature/order/widget/card_content_widget.dart';
import 'package:pharmacy_online/feature/order/widget/medicine_list_widget.dart';
import 'package:pharmacy_online/feature/order/widget/row_content_widget.dart';
import 'package:pharmacy_online/feature/order/widget/tracking_content_widget.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/utils/util/date_format.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'OrderDetailScreen';

  const OrderDetailScreen({super.key});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends BaseConsumerState<OrderDetailScreen> {
  Timer? timer;

  @override
  void initState() {
    // เมื่อ Widget ถูกสร้างขึ้น ในช่วงที่ widget ยังไม่ถูก build บนหน้าจอ
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // ดึงข้อมูลรายละเอียดคำสั่งซื้อ (orderDetail) จาก state โดยใช้ orderControllerProvider
      final orderDetail = ref
          .watch(orderControllerProvider.select((value) => value.orderDetail));

      // ดึงข้อมูลรายละเอียดของร้าน (pharmacyDetail) และตรวจสอบรีวิว (reviewAlready)
      await ref
          .read(storeControllerProvider.notifier)
          .onGetPharmacyDetail('${orderDetail.value?.pharmacyId}');

      await ref
          .read(orderControllerProvider.notifier)
          .onCheckReviewAlready('${orderDetail.value?.id}');
    });

    // สร้าง Timer ที่ทำงานเป็นระยะๆ เพื่อตรวจสอบข้อมูลอัพเดท
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      // ดึงข้อมูลรายละเอียดคำสั่งซื้อ (orderDetail) จาก state โดยใช้ orderControllerProvider
      final orderDetail = ref
          .watch(orderControllerProvider.select((value) => value.orderDetail))
          .value;

      // ดึงข้อมูลที่ต้องการจาก orderDetail
      final billStatus = orderDetail?.status;
      final uid = orderDetail?.uid;
      final pharmacyId = orderDetail?.pharmacyId;
      final orderId = orderDetail?.id;
      final cartId = orderDetail?.cartId;

      // ดึงข้อมูลตะกร้า (myCart) และคำสั่งซื้อ (order)
      await ref.read(myCartControllerProvider.notifier).onGetCart(
            '$uid',
            '$pharmacyId',
            billStatus!,
            isLoading: false,
            cartId: cartId,
          );

      await ref.read(orderControllerProvider.notifier).onGetOrder(
            '$uid',
            '$pharmacyId',
            billStatus,
            isLoading: false,
            orderId: orderId,
          );

      // ดึงข้อมูลรายละเอียดคำสั่งซื้อ (orderItem) จาก orderDetail
      final orderItem = orderDetail;

      final itemTime = orderItem?.createAt;

      final fullName = orderItem?.myCart?.fullName;
      final id = orderItem?.id;
      final isPayment = billStatus == OrderStatus.waitingPayment;
      // กำหนดตัวแปล currentTime เป็นเวลาปัจจุบัน
      final currentTime = DateTime.now();
      // ตรวจสอบว่าเวลาที่ผ่านมาตั้งแต่ itemTime ถึง currentTime มีมากกว่า 4 ชั่วโมงหรือไม่
      final isMoreThan4Hours = currentTime.difference(itemTime!).inHours > 4;
      // ใช้ Riverpod เพื่อดึงค่า isPharmacy จาก ProfileControllerProvider
      final isPharmacy = ref
          .watch(profileControllerProvider.select((value) => value.isPharmacy));
      // ตรวจสอบเงื่อนไขว่าเวลามากกว่า 4 ชั่วโมง และ isPayment เป็นจริงหรือไม่
      if (isMoreThan4Hours && isPayment) {
        // ลบคำสั่งซื้อโดยเรียกใช้ onDeleteOrder จาก orderControllerProvider
        final result = await ref
            .read(orderControllerProvider.notifier)
            .onDeleteOrder('$id', '$cartId');

        if (result) {
          // สร้างการแจ้งเตือนโดยเรียกใช้ onPostNotification จาก HomeControllerProvider
          await ref.read(homeControllerProvider.notifier).onPostNotification(
                'คำสั่งซื้อถูกยกเลิกเนื่องจากไม่ได้ชำระเงินในระยะเวลาที่กำหนด',
                'cancelChat',
                '$uid',
              );
        }
      }

      if (billStatus == OrderStatus.delivering) {
        final updateAt = orderItem?.updateAt;
        final isMoreThan4Hours = currentTime.difference(updateAt!).inHours > 4;
        if (isMoreThan4Hours) {
          final result =
              await ref.read(orderControllerProvider.notifier).onUpdateOrder(
                    '$id',
                    '$cartId',
                    status: OrderStatus.completed,
                  );
          if (result) {
            await ref.read(orderControllerProvider.notifier).onGetAllOrder(
                  isPharmacy,
                );

            await ref.read(orderControllerProvider.notifier).onGetOrder(
                  '$uid',
                  '$pharmacyId',
                  OrderStatus.completed,
                  orderId: orderId,
                );

            await ref.read(homeControllerProvider.notifier).onPostNotification(
                  '$fullName ยืนยันการจัดส่งสำเร็จ',
                  OrderStatus.completed.name,
                  '$pharmacyId',
                );

            await ref.read(homeControllerProvider.notifier).onPostNotification(
                  'ยืนยันการจัดส่งสำเร็จ',
                  OrderStatus.completed.name,
                  '$uid',
                );
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูล isPharmacy จาก ProfileControllerProvider
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));

    // ดึงข้อมูลรายละเอียดคำสั่งซื้อ (orderDetail) จาก orderControllerProvider
    final orderDetail =
        ref.watch(orderControllerProvider.select((value) => value.orderDetail));
    // ดึงข้อมูลตะกร้า (myCart) จาก myCartControllerProvider
    final myCart =
        ref.watch(myCartControllerProvider.select((value) => value.myCart));

    // ดึงข้อมูลการรีวิว (isAlreadyReview) จาก orderControllerProvider
    final isAlreadyReview = ref.watch(
      orderControllerProvider.select(
        (value) => value.isAlreadyReview,
      ),
    );

    // ตรวจสอบว่าสถานะคำสั่งซื้อเป็น completed หรือไม่
    final isCompletedStatus =
        orderDetail.value?.status == OrderStatus.completed;

    return BaseScaffold(
      bgColor: AppColor.themLineColor,
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'คำสั่งซื้อ',
          style: AppStyle.txtHeader3,
        ),
        actions: [
          // ส่วนของปุ่ม 'ยกเลิกคำสั่งซื้อ'
          if (isPharmacy && !isCompletedStatus) ...[
            GestureDetector(
              onTap: () async {
                // แสดง Dialog ยืนยันการยกเลิกคำสั่งซื้อ
                await showDialog(
                  context: context,
                  builder: (_) {
                    return BaseDialog(
                      message: 'ต้องการยกเลิกคำสั่งซื้อ?',
                      hasCancel: true,
                      onClick: () async {
                        final _orderDetail = orderDetail.value;
                        // เรียกใช้งาน onDeleteOrder เพื่อยกเลิกคำสั่งซื้อ
                        final result = await ref
                            .read(orderControllerProvider.notifier)
                            .onDeleteOrder(
                              '${_orderDetail?.id}',
                              '${_orderDetail?.cartId}',
                            );

                        if (result) {
                          // อัปเดตข้อมูลคำสั่งซื้อหลังจากยกเลิก
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
      bodyBuilder: (context, constrained) {
        return AsyncValueWidget(
          value: orderDetail,
          data: (_orderDetail) {
            final _myCart = myCart.value;
            final id = _orderDetail?.id;
            final cartId = _orderDetail?.cartId;
            final uid = _orderDetail?.uid;
            final pharmacyId = _orderDetail?.pharmacyId;
            final orderNumber = _orderDetail?.orderNumber ?? 'ไม่ระบุ';

            final cartCreatedAt = _myCart?.createAt;
            final convertCreateAt =
                ref.read(baseDateFormatterProvider).convertStringToDateTime(
                      '${_orderDetail?.createAt ?? cartCreatedAt}',
                    );
            final createAt = ref
                .read(baseDateFormatterProvider)
                .formatDateWithFreeStyleFormat('dd/MM/yyyy', convertCreateAt);
            final createAtTime = ref
                .read(baseDateFormatterProvider)
                .formatDateWithFreeStyleFormat('HH:mm', convertCreateAt);
            final diagnose = _orderDetail?.diagnose ?? 'ไม่ระบุ';
            final moreDetail = _orderDetail?.moreDetail ?? 'ไม่ระบุ';
            final cartDetail = _orderDetail?.myCart;
            final fullName = cartDetail?.fullName;
            final phone = cartDetail?.phone;
            final nameStore = cartDetail?.nameStore ?? _myCart?.nameStore;
            final address = cartDetail?.address;
            final district = cartDetail?.district;
            final subDistrict = cartDetail?.subDistrict;
            final province = cartDetail?.province;
            final postNumber = cartDetail?.postNumber;
            final summaryPrice =
                cartDetail?.sumamryPrice ?? _myCart?.sumamryPrice;
            final medicineList = cartDetail?.medicineList;
            final deliverySlip = _orderDetail?.deliverySlip;
            final bankTransferSlip = _orderDetail?.bankTransferSlip;
            final deliveryTextBtn = deliverySlip != null
                ? (_orderDetail?.status == OrderStatus.delivering ||
                        _orderDetail?.status == OrderStatus.completed
                    ? 'ดูรูปภาพ'
                    : 'แก้ไขรูปภาพ')
                : 'เพิ่มรูปภาพ';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ส่วนรายละเอียดคำสั่งซื้อ
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
                            content: orderNumber,
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
                            content: '$createAtTime น.',
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          RowContentWidget(
                            header: 'ราคารวมทั้งหมด:',
                            content: '$summaryPrice บาท',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    // ส่วนที่แสดงรายละเอียดสินค้า
                    Text(
                      'ข้อมูลในการจัดส่ง',
                      style: AppStyle.txtHeader3,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    // ส่วนที่แสดงข้อมูลที่อยู่จัดส่ง
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
                            '$address $district $subDistrict $province $postNumber',
                            style: AppStyle.txtCaption.copyWith(
                              color: AppColor.themeGrayLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    // ส่วนที่แสดงรายละเอียดสินค้า
                    Text(
                      'รายละเอียดยา',
                      style: AppStyle.txtHeader3,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    // ส่วนที่แสดงรายการยา
                    Container(
                      padding: const EdgeInsets.all(16).r,
                      color: AppColor.themeWhiteColor,
                      child: MedicineListWidget(
                        isOrder: true,
                        medicineList: medicineList ?? [],
                        onChange: (val) {},
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    // ส่วนที่แสดงวินิจฉัยอาการและรายละเอียดเพิ่มเติม
                    CardContentWidget(
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'วินิจฉัยอาการป่วย',
                            style: AppStyle.txtBody
                                .copyWith(color: AppColor.themePrimaryColor),
                          ),
                          Text(
                            '• $diagnose',
                            style: AppStyle.txtBody,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            'รายละเอียดเพิ่มเติม',
                            style: AppStyle.txtBody
                                .copyWith(color: AppColor.themePrimaryColor),
                          ),
                          Text(
                            //'• $moreDetail',
                            moreDetail != '' ? '• $moreDetail' : 'ไม่ระบุ',
                            style: AppStyle.txtBody,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            'วิธีการใช้ยา',
                            style: AppStyle.txtBody
                                .copyWith(color: AppColor.themePrimaryColor),
                          ),
                          const RowContentWidget(
                            isBold: true,
                            header: '     ชื่อยา',
                            content: 'วิธีการใช้/คำแนะนำ',
                          ),
                          if (medicineList == null) ...[
                            const SizedBox.shrink(),
                          ] else ...[
                            for (final medicineItem in medicineList) ...[
                              // ส่วนที่แสดงรายละเอียดของแต่ละรายการยา
                              RowContentWidget(
                                isBold: true,
                                header: ' ${medicineItem.name}',
                                content: medicineItem.howToUse ?? 'ไม่ระบุ',
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    // ส่วนที่แสดงสถานะและข้อมูลการติดตามสินค้า
                    Text(
                      'ติดตามคำสั่งซื้อ',
                      style: AppStyle.txtHeader3,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    // ส่วนที่แสดงสถานะการชำระเงิน
                    TrackingContentWidget(
                      contentHeight:
                          _orderDetail?.status != OrderStatus.waitingPayment
                              ? 10.h
                              : null,
                      isSuccess: _orderDetail?.status !=
                              OrderStatus.waitingPayment ||
                          (_orderDetail?.status == OrderStatus.waitingPayment &&
                              bankTransferSlip != null) ||
                          _orderDetail?.status == OrderStatus.completed,
                      // กำหนดการแสดงปุ่มสแกน QR Code ขึ้นอยู่กับสถานะการชำระเงิน
                      hasBtn: !isPharmacy &&
                          _orderDetail?.status == OrderStatus.waitingPayment &&
                          bankTransferSlip == null,
                      onTap: () {
                        // ส่วนของการเปิดหน้าจอสแกน QR Code
                        Navigator.of(context).pushNamed(
                          UploadBankTransferScreen.routeName,
                        );
                      },
                      number: '1',
                      title: 'การชำระเงิน',
                      // กำหนดข้อความสถานะการชำระเงิน
                      content: (_orderDetail?.status ==
                                      OrderStatus.waitingPayment &&
                                  bankTransferSlip == null) &&
                              _orderDetail?.status != OrderStatus.completed
                          ? (isPharmacy ? 'รอลูกค้าชำระเงิน' : 'กรุณาชำระเงิน')
                          : (_orderDetail?.status ==
                                      OrderStatus.waitingPayment &&
                                  bankTransferSlip != null
                              ? (isPharmacy
                                  ? 'ลูกค้าชำระเงินแล้ว'
                                  : 'ชำระเงินเรียบร้อย')
                              : null),
                      btnTxt:
                          (bankTransferSlip == null ? 'สแกน QR Code' : 'แก้ไข'),
                      //no1
                    ),
                    // ส่วนของตรวจสอบการชำระ
                    TrackingContentWidget(
                      // ตรวจสอบสถานะคำสั่งซื้อ
                      isSuccess: _orderDetail?.status !=
                              OrderStatus.waitingConfirmOrder &&
                          _orderDetail?.status != OrderStatus.confirmOrder &&
                          _orderDetail?.status != OrderStatus.waitingPayment,
                      // ตรวจสอบว่ามีปุ่มดูรูปภาพหรือไม่
                      hasBtn: _orderDetail?.status !=
                              OrderStatus.waitingConfirmOrder &&
                          _orderDetail?.status != OrderStatus.confirmOrder &&
                          bankTransferSlip != null,
                      // ฟังก์ชันเมื่อกดปุ่มให้ไปหน้าโอนเงิน
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          EvidenceBankTransferScreen.routeName,
                        );
                      },
                      number: '2',
                      title: 'ตรวจสอบการชำระ',
                      content:
                          _orderDetail?.status == OrderStatus.waitingPayment &&
                                  bankTransferSlip != null
                              ? (isPharmacy
                                  ? 'กรุณาตรวจสอบการชำระเงิน'
                                  : 'รอการตรวจสอบการชำระเงิน')
                              : null,
                      contentHeight: _orderDetail?.status !=
                                  OrderStatus.waitingConfirmOrder &&
                              _orderDetail?.status !=
                                  OrderStatus.confirmOrder &&
                              _orderDetail?.status != OrderStatus.waitingPayment
                          ? 50.h
                          : null,
                      btnTxt: _orderDetail?.status !=
                                  OrderStatus.waitingConfirmOrder &&
                              _orderDetail?.status !=
                                  OrderStatus.confirmOrder &&
                              bankTransferSlip != null
                          ? 'ดูรูปภาพ'
                          : '',
                      onTapSecond: () async {
                        await ref
                            .read(orderControllerProvider.notifier)
                            .onUpdateOrder(
                              '$id',
                              '$cartId',
                              status: OrderStatus.waitingDelivery,
                            );
                        await ref
                            .read(orderControllerProvider.notifier)
                            .onGetAllOrder(
                              isPharmacy,
                            );
                        await ref
                            .read(orderControllerProvider.notifier)
                            .onGetOrder(
                              '$uid',
                              '$pharmacyId',
                              OrderStatus.waitingDelivery,
                              orderId: id,
                            );

                        await ref
                            .read(homeControllerProvider.notifier)
                            .onPostNotification(
                              'ร้าน$nameStore ยืนยันการชำระเงิน เตรียมทำการจัดส่ง',
                              OrderStatus.waitingDelivery.name,
                              '$uid',
                            );
                      },
                      // ตรวจสอบว่ามีปุ่มยืนยันรายการหรือไม่
                      hasSecondBtn: bankTransferSlip != null &&
                          _orderDetail?.status == OrderStatus.waitingPayment &&
                          isPharmacy,
                      btnTxtSecond: bankTransferSlip != null &&
                              _orderDetail?.status == OrderStatus.waitingPayment
                          ? 'ยืนยันรายการ'
                          : '',
                    ),
                    TrackingContentWidget(
                      // ตรวจสอบสถานะคำสั่งซื้อ
                      isSuccess:
                          _orderDetail?.status == OrderStatus.delivering ||
                              _orderDetail?.status == OrderStatus.completed,
                      // บรรทัดนี้ตรวจสอบสถานะคำสั่งซื้อ หากเป็น "กำลังจัดส่ง" หรือ "เสร็จสิ้น" จะแสดงผลลัพธ์แบบสำเร็จ

                      // ตรวจสอบว่าควรแสดงปุ่มหรือไม่
                      hasBtn: (_orderDetail?.status ==
                                  OrderStatus.waitingDelivery &&
                              isPharmacy) ||
                          _orderDetail?.status == OrderStatus.delivering ||
                          _orderDetail?.status == OrderStatus.completed,
                      onTap: () {
                        // หากคำสั่งซื้ออยู่ในสถานะ "กำลังจัดส่ง" หรือ "เสร็จสิ้น" ให้แสดงหน้าจอหลักฐานการจัดส่งสินค้า
                        if (_orderDetail?.status == OrderStatus.delivering ||
                            _orderDetail?.status == OrderStatus.completed) {
                          Navigator.of(context).pushNamed(
                            EvidenceTransportationScreen.routeName,
                          );
                          return; // หยุดการทำงานของฟังก์ชัน
                        }
                        if (isPharmacy) {
                          // หากผู้ใช้เป็นเภสัชกร ให้ไปยังหน้าจอเพิ่มรูปภาพการจัดส่งสินค้า
                          Navigator.of(context)
                              .pushNamed(UploadTransportationScreen.routeName);
                          return;
                        }
                        // หากผู้ใช้ไม่ใช่เภสัชกร ให้แสดงหน้าจอหลักฐานการจัดส่งสินค้า
                        Navigator.of(context)
                            .pushNamed(EvidenceTransportationScreen.routeName);
                      },
                      number: '3',
                      title: 'ดำเนินการจัดส่ง',
                      contentHeight:
                          _orderDetail?.status == OrderStatus.completed
                              ? 50.h
                              : null,
                      content: //_orderDetail?.status == OrderStatus.delivering
                          _orderDetail?.status == OrderStatus.waitingDelivery
                              ? (!isPharmacy
                                  ? 'รอร้านทำการจัดส่ง'
                                  : (isPharmacy && deliverySlip == null
                                      ? 'กรุณาเพิ่มรูปภาพการจัดส่งสินค้า'
                                      : 'กรุณายืนยันการจัดส่ง'))
                              : null,
//no3
                      btnTxt: _orderDetail?.status ==
                                  OrderStatus.waitingDelivery ||
                              _orderDetail?.status == OrderStatus.delivering ||
                              _orderDetail?.status == OrderStatus.completed
                          ? (isPharmacy ? deliveryTextBtn : 'ดูรูปภาพ')
                          : '',

                      // ตรวจสอบว่าควรแสดงปุ่มที่สองหรือไม่ โดยจะแสดงปุ่มเมื่อหลักฐานการจัดส่งสินค้าพร้อมแล้วและคำสั่งซื้ออยู่ในสถานะ "รอจัดส่ง"
                      hasSecondBtn: deliverySlip != null &&
                          _orderDetail?.status == OrderStatus.waitingDelivery &&
                          isPharmacy,
                      btnTxtSecond:
                          _orderDetail?.status == OrderStatus.waitingDelivery
                              ? 'ยืนยันรายการ'
                              : '',
                      // ฟังก์ชันเมื่อกดปุ่มที่สอง
                      onTapSecond: () async {
                        // อัพเดทสถานะคำสั่งซื้อเป็น "กำลังจัดส่ง"
                        await ref
                            .read(orderControllerProvider.notifier)
                            .onUpdateOrder(
                              '$id',
                              '$cartId',
                              status: OrderStatus.delivering,
                            );
                        // ดึงข้อมูลคำสั่งซื้อทั้งหมดและคำสั่งซื้อเฉพาะ
                        await ref
                            .read(orderControllerProvider.notifier)
                            .onGetAllOrder(
                              isPharmacy,
                            );
                        await ref
                            .read(orderControllerProvider.notifier)
                            .onGetOrder(
                              '$uid',
                              '$pharmacyId',
                              OrderStatus.waitingDelivery,
                              orderId: id,
                            );
                        // โนติยืนยันการจัดส่ง
                        await ref
                            .read(homeControllerProvider.notifier)
                            .onPostNotification(
                              'ร้าน$nameStore ทำการจัดส่งเรียบร้อย',
                              OrderStatus.delivering.name,
                              '$uid',
                            );
                      },
                    ),
                    TrackingContentWidget(
                      // ตรวจสอบว่าคำสั่งซื้อสำเร็จแล้วหรือไม่
                      isSuccess: _orderDetail?.status == OrderStatus.completed,
                      hasBtn: !isPharmacy &&
                          _orderDetail?.status == OrderStatus.delivering,
                      isSecondBtn: false,
                      onTap: () async {
                        // แสดงหน้าต่างยืนยันการสำเร็จ
                        showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'ยืนยันคำสั่งซื้อสำเร็จ',
                                hasCancel: true,
                                onClick: () async {
                                  // อัพเดทสถานะคำสั่งซื้อเป็น "เสร็จสมบูรณ์"
                                  final result = await ref
                                      .read(orderControllerProvider.notifier)
                                      .onUpdateOrder(
                                        '$id',
                                        '$cartId',
                                        status: OrderStatus.completed,
                                      );
                                  // หากอัพเดทสำเร็จ ทำการดึงข้อมูลคำสั่งซื้อทั้งหมด
                                  if (result) {
                                    await ref
                                        .read(orderControllerProvider.notifier)
                                        .onGetAllOrder(
                                          isPharmacy,
                                        );

                                    // ดึงข้อมูลคำสั่งซื้อที่มี ID ตรงกับคำสั่งซื้อปัจจุบัน
                                    await ref
                                        .read(orderControllerProvider.notifier)
                                        .onGetOrder(
                                          '$uid',
                                          '$pharmacyId',
                                          OrderStatus.completed,
                                          orderId: id,
                                        );

                                    // โนติยืนยันการจัดส่งสำเร็จ
                                    await ref
                                        .read(homeControllerProvider.notifier)
                                        .onPostNotification(
                                          '$fullName ยืนยันการจัดส่งสำเร็จ',
                                          OrderStatus.completed.name,
                                          '$pharmacyId',
                                        );

                                    await ref
                                        .read(homeControllerProvider.notifier)
                                        .onPostNotification(
                                          'ยืนยันการจัดส่งสำเร็จ',
                                          OrderStatus.completed.name,
                                          '$uid',
                                        );

                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushNamed(AddReviewScreen.routeName);
                                  } else {
                                    // แสดง Toast แจ้งเตือนหากไม่สามารถอัพเดทได้
                                    Fluttertoast.showToast(
                                      msg: "ไม่สามารถยืนยันได้",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                },
                              );
                            });
                      },
                      number: '4',
                      title: 'การจัดส่งสำเร็จ',
                      btnTxt: 'ยืนยัน',
                      //ของฝั่งร้านขายยา
                      content: _orderDetail?.status == OrderStatus.delivering
                          ? (isPharmacy
                              ? 'รอลูกค้ายืนยันการจัดส่ง'
                              : 'กรุณายืนยันการจัดส่งเมื่อได้รับของแล้ว')
                          : (_orderDetail?.status == OrderStatus.completed
                              ? isPharmacy
                                  ? null //'ลูกค้ายืนยันการจัดส่งแล้ว'
                                  : null
                              : null),
                    ),
                    // กำหนดเงื่อนไขว่าหากสถานะการจัดส่งสินค้าสำเร็จ ผู้ใช้ไม่ใช่เภสัชกร และยังไม่ได้รีวิวสินค้า
                    if (_orderDetail?.status == OrderStatus.completed &&
                        !isPharmacy &&
                        !isAlreadyReview) ...[
                      SizedBox(
                        height: 16.h,
                      ),
                      // แสดงปุ่ม "เพิ่มรีวิว"
                      BaseButton(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AddReviewScreen.routeName);
                        },
                        text: 'เพิ่มรีวิว',
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
