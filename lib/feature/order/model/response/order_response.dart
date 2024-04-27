import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';

part 'order_response.freezed.dart';
part 'order_response.g.dart';

@immutable //นำมาใช้เพื่อระบุว่าคลาส OrderResponse เป็น immutable และไม่สามารถเปลี่ยนแปลงค่าภายในได้หลังจากถูกสร้างขึ้น.
@freezed //ใช้ในการสร้างคลาสที่เป็น immutable อัตโนมัติ จากนั้นใน annotation ยังประกาศ _OrderResponse ซึ่งเป็นคลาสที่ถูกสร้างขึ้นโดย Freezed.
abstract class OrderResponse with _$OrderResponse {
  @JsonSerializable() //ใช้ในการสร้างเมทอด toJson() และ fromJson() โดยอัตโนมัติจากคุณสมบัติของคลาส.
  const factory OrderResponse({
    String? id,
    String? pharmacyId,
    String? uid,
    String? cartId,
    CartResponse? myCart,
    OrderStatus? status,
    String? diagnose,
    String? orderNumber,
    String? moreDetail,
    String? bankTransferSlip,
    String? deliverySlip,
    String? bankTransferDate,
    double? bankTotalPriceSlip,
    DateTime? createAt,
    DateTime? updateAt,
  }) = _OrderResponse;

  // สร้าง factory constructor สำหรับแปลง JSON เป็นออบเจ็กต์ OrderResponse
  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}

// OrderResponse คือคลาสที่ใช้ในการเก็บข้อมูลของคำสั่งซื้อ
// มีคุณสมบัติต่าง ๆ ที่เป็น nullable ตามที่ระบุใน parameter ของ constructor
// เมื่อใช้ Freezed Annotation, จะได้คลาสอื่น ๆ ที่ถูกสร้างขึ้นโดยอัตโนมัติ
// ทำให้มีความสะดวกในการใช้งานและการแปลงข้อมูล

// สามารถแปลง OrderResponse ไปเป็น JSON ได้โดยใช้ toJson()
// และสามารถสร้าง OrderResponse จาก JSON ได้โดยใช้ fromJson()
