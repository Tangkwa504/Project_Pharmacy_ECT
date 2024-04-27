import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';

/// คลาส OrderRequest ใช้สำหรับสร้างอ็อบเจกต์ที่เกี่ยวข้องกับข้อมูลของคำสั่งซื้อ
class OrderRequest {
  final String? id;
  final String? pharmacyId;
  final String? uid;
  final String? storeId;
  final String? cartId;
  final String? orderNumber;
  final OrderStatus? status;
  final XFile? bankTransferSlip;
  final XFile? deliverySlip;
  final String? bankTransferDate;
  final double? bankTotalPriceSlip;
  final String? diagnose;
  final String? moreDetail;
  final List<Map<String, String>>? howToUse;
  final bool isPharmacy;

  /// สร้างอ็อบเจกต์ OrderRequest ด้วยพารามิเตอร์ที่ระบุ
  OrderRequest({
    this.id,
    this.pharmacyId,
    this.uid,
    this.storeId,
    this.orderNumber,
    this.cartId,
    this.status,
    this.bankTransferSlip,
    this.deliverySlip,
    this.bankTransferDate,
    this.bankTotalPriceSlip,
    this.diagnose,
    this.moreDetail,
    this.howToUse,
    this.isPharmacy = false,
  });

  /// แปลงข้อมูลในคลาสเป็นรูปแบบ JSON สำหรับการส่งข้อมูล
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pharmacyId': pharmacyId,
      'uid': uid,
      'orderNumber': orderNumber,
      'cartId': cartId,
      'storeId': storeId,
      'status': status,
      'bankTransferSlip': bankTransferSlip,
      'deliverySlip': deliverySlip,
      'bankTransferDate': bankTransferDate,
      'bankTotalPriceSlip': bankTotalPriceSlip,
      'diagnose': diagnose,
      'moreDetail': moreDetail,
      'howToUse': howToUse,
      'isPharmacy': isPharmacy,
    };
  }
}
