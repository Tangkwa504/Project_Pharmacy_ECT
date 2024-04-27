import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
import 'package:pharmacy_online/feature/order/enum/field_bank_transfer_enum.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/base_permission_handler.dart';
import 'package:pharmacy_online/utils/util/date_format.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class UploadBankTransferScreen extends ConsumerStatefulWidget {
  static const routeName = 'UploadBankTransferScreen';

  const UploadBankTransferScreen({super.key});

  @override
  _UploadBankTransferScreenState createState() =>
      _UploadBankTransferScreenState();
}

class _UploadBankTransferScreenState
    extends BaseConsumerState<UploadBankTransferScreen> {
  final _globalKey = GlobalKey();
  TextEditingController slipDateTime = TextEditingController();
  XFile? evidenceImg;
  final formKey = GlobalKey<BaseFormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลร้านเภสัช
    final pharmacyDetail = ref
        .watch(storeControllerProvider.select((value) => value.pharmacyDetail));
    // ดึงข้อมูลคำสั่งซื้อ
    final orderDetail =
        ref.watch(orderControllerProvider.select((value) => value.orderDetail));

    // ดึงข้อมูลต่าง ๆ จากคำสั่งซื้อ
    final uid = orderDetail.value?.uid;
    final pharmacyId = orderDetail.value?.pharmacyId;
    final summaryPrice = orderDetail.value?.myCart?.sumamryPrice;
    final cartId = orderDetail.value?.cartId;
    final id = orderDetail.value?.id;
    final fullName = orderDetail.value?.myCart?.fullName;
    final nameStore = orderDetail.value?.myCart?.nameStore;

    return AsyncValueWidget(
      value: pharmacyDetail,
      data: (_pharmacyDetail) {
        // ดึงข้อมูล QR Code จากร้านเภสัช
        final qrCode = _pharmacyDetail?.qrCode;

        return BaseScaffold(
          appBar: BaseAppBar(
            bgColor: AppColor.themeWhiteColor,
            title: Text(
              'ชำระค่าสินค้า',
              style: AppStyle.txtHeader3,
            ),
            elevation: 0,
          ),
          bodyBuilder: (context, constrained) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16).r,
                child: BaseForm(
                  key: formKey,
                  onChanged:
                      ref.read(orderControllerProvider.notifier).onChanged,
                  child: Column(
                    children: [
                      // แสดง QR Code และปุ่ม Download
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32).r,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColor.themePrimaryColor,
                                width: 1, // red as border color
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  16,
                                ),
                              ),
                            ),
                            child: RepaintBoundary(
                              key: _globalKey,
                              child: BaseImageView(
                                url: '$qrCode',
                                width: 250.w,
                                //height: 250.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () async {
                                // ขออนุญาตเข้าถึงสิทธิ์เข้าถึงไฟล์ในอุปกรณ์
                                final granted = await ref
                                    .read(basePermissionHandlerProvider)
                                    .requestStoragePermission();

                                // หากได้รับอนุญาต
                                if (granted) {
                                  // ทำการสร้างภาพจาก QR Code และบันทึกลงในแกลเลอรี
                                  RenderRepaintBoundary boundary = _globalKey
                                          .currentContext!
                                          .findRenderObject()
                                      as RenderRepaintBoundary;
                                  final image = await boundary.toImage();
                                  ByteData? byteData = await (image.toByteData(
                                    format: ImageByteFormat.png,
                                  ));
                                  if (byteData != null) {
                                    final result =
                                        await ImageGallerySaver.saveImage(
                                      byteData.buffer.asUint8List(),
                                    );
                                    if (result['isSuccess']) {
                                      Fluttertoast.showToast(
                                        msg: "Downloaded",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "ไม่สามารถ Download ได้",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  }
                                }
                              },
                              child: Assets.icons.icDownload.svg(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      // แสดงจำนวนเงินที่ต้องชำระ
                      Text(
                        'จำนวนเงิน $summaryPrice บาท',
                        style: AppStyle.txtHeader3,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      // กล่องกรอกวันที่ชำระ
                      BaseTextField(
                        label: 'วันที่ชำระ',
                        isReadOnly: true,
                        controller: slipDateTime,
                        isShowLabelField: true,
                        onTap: () async {
                          // เลือกวันที่และเวลา
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                          );

                          final selectedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          // นำวันที่และเวลาที่เลือกมาแสดงบน TextField
                          if (picked != null && selectedTime != null) {
                            final hour =
                                selectedTime.hour.toString().padLeft(2, "0");
                            final min =
                                selectedTime.minute.toString().padLeft(2, "0");

                            final result = ref
                                .read(baseDateFormatterProvider)
                                .formatDateTimeWithNameOfMonth(
                                  picked,
                                  'dd/MM/yyyy',
                                );

                            slipDateTime.text = '$result $hour:$min';

                            // นำวันที่และเวลาที่เลือกไปอัพเดทใน Order Controller
                            ref
                                .read(orderControllerProvider.notifier)
                                .setBankTransferDateTime('$result $hour:$min');
                          }
                        },
                        validator: Validators.combine(
                          [
                            Validators.withMessage(
                              "กรุณาระบุวันที่ชำระ",
                              Validators.isEmpty,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      // กล่องกรอกจำนวนเงิน
                      BaseTextField(
                        fieldKey: FieldBankTransfer.payPrice,
                        label: 'จำนวนเงิน',
                        textInputType: TextInputType.number,
                        isShowLabelField: true,
                        validator: Validators.combine(
                          [
                            Validators.withMessage(
                              "กรุณากรอกจำนวนเงิน",
                              Validators.isEmpty,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      // กล่องเพื่ออัพโหลดรูปภาพหลักฐานการโอน
                      BaseUploadImage(
                        label: 'หลักฐานการโอน',
                        onUpload: (val) {
                          setState(() {
                            evidenceImg = val;
                          });
                        },
                      ),
                      // แสดงรูปภาพหลักฐานการโอนหากมีการอัพโหลด
                      if (evidenceImg != null) ...[
                        SizedBox(
                          height: 8.h,
                        ),
                        BaseImageView(
                          file: File(evidenceImg!.path),
                          width: 250.w,
                          //height: 150.h,
                          fit: BoxFit.contain,
                        ),
                      ],
                      SizedBox(
                        height: 16.h,
                      ),
                      // ปุ่มยืนยันการชำระเงิน
                      BaseButton(
                        onTap: () {
                          formKey.currentState?.save(
                            onSave: (_) async {
                              // ตรวจสอบว่าวันที่ชำระและหลักฐานการโอนถูกกรอกครบหรือไม่
                              if (slipDateTime.text.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "กรุณาระบุวันที่ชำระ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                return;
                              }

                              if (evidenceImg == null) {
                                Fluttertoast.showToast(
                                  msg: "กรุณาอัปโหลดสลิป",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                return;
                              }

                              // ทำการอัพโหลดข้อมูลการชำระเงิน
                              final result = await ref
                                  .read(orderControllerProvider.notifier)
                                  .onUpdatBankTransfer(
                                    '$id',
                                    '$cartId',
                                    slipDateTime.text,
                                    evidenceImg!,
                                  );

                              // หากการอัพโหลดสำเร็จ
                              if (result) {
                                // ทำการโนติให้ลูกค้าและร้านเภสัช
                                await ref
                                    .read(homeControllerProvider.notifier)
                                    .onPostNotification(
                                      '$fullName ทำการชำระเงินแล้ว',
                                      OrderStatus.waitingPayment.name,
                                      '$pharmacyId',
                                    );

                                await ref
                                    .read(homeControllerProvider.notifier)
                                    .onPostNotification(
                                      'รอร้าน$nameStore ตรวจสอบการชำระเงิน',
                                      OrderStatus.waitingPayment.name,
                                      '$uid',
                                    );

                                // ดึงข้อมูลคำสั่งซื้อที่มี ID ตรงกับคำสั่งซื้อปัจจุบัน
                                await ref
                                    .read(orderControllerProvider.notifier)
                                    .onGetOrder(
                                      '$uid',
                                      '$pharmacyId',
                                      OrderStatus.waitingPayment,
                                      orderId: id,
                                    );

                                //Toast แสดงข้อความ "อัพโหลดสลิปสำเร็จ" บนหน้าจอเป็นเวลาสั้นๆ โดย Toast จะแสดงอยู่ด้านล่างหน้าจอ
                                Fluttertoast.showToast(
                                  msg: "อัปโหลดสลิปสำเร็จ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );

                                // ปิดหน้าจอ
                                Navigator.of(context).pop();
                              } else {
                                // แสดง Toast แจ้งเตือนหากอัพโหลดไม่สำเร็จ
                                Fluttertoast.showToast(
                                  msg: "อัปโหลดสลิปไม่สำเร็จ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }
                            },
                          );
                        },
                        text: 'ยืนยันการชำระเงิน',
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
