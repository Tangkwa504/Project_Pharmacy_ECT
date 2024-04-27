import 'package:flutter/widgets.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';

extension OrderStatusExtension on OrderStatus {
  String get statusLabelUser {
    switch (this) {
      case OrderStatus.waitingConfirmOrder:
        return 'รอยืนยันออเดอร์';
      case OrderStatus.waitingPayment:
        return 'รอการชำระเงิน';
      case OrderStatus.confirmOrder:
        return 'ยืนยันออเดอร์';
      case OrderStatus.paidPayment:
        return 'ยืนยันการชำระเงินแล้ว';
      case OrderStatus.waitingDelivery:
        return 'รอการจัดส่ง';
      case OrderStatus.delivering:
        return 'ที่ต้องได้รับ';
      case OrderStatus.completed:
        return 'สำเร็จ';
      default:
        return 'รอยืนยันออเดอร์';
    }
  }

  String get statusLabelPharmacy {
    switch (this) {
      case OrderStatus.waitingConfirmOrder:
        return 'รอยืนยันออเดอร์';
      case OrderStatus.waitingPayment:
        return 'รอการชำระเงิน';
      case OrderStatus.confirmOrder:
        return 'ยืนยันออเดอร์';
      case OrderStatus.paidPayment:
        return 'ยืนยันการชำระเงินแล้ว';
      case OrderStatus.waitingDelivery:
        return 'รอการจัดส่ง';
      case OrderStatus.delivering:
        return 'รอยืนยันการจัดส่ง';
      case OrderStatus.completed:
        return 'สำเร็จ';
      default:
        return 'รอยืนยันออเดอร์';
    }
  }

  Color get statusLabelColor {
    switch (this) {
      case OrderStatus.waitingConfirmOrder:
        return AppColor.themeYellowColor;
      case OrderStatus.waitingPayment:
        return AppColor.errorColor;
      case OrderStatus.paidPayment:
        return AppColor.themeSuccess;
      case OrderStatus.waitingDelivery:
        return AppColor.errorColor;
      case OrderStatus.delivering:
        return AppColor.errorColor;
      case OrderStatus.completed:
        return AppColor.themeSuccess;
      default:
        return AppColor.themeYellowColor;
    }
  }
}
