import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/feature/order/model/response/order_response.dart';

part 'order_state.freezed.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState({
    /*เก็บข้อมูลฟอร์มหลักที่ใช้ในการสั่งซื้อ*/
    BaseFormData? baseFormData,
    /*เก็บข้อความ error */
    String? errMsg,
    /*เก็บข้อมูลรายละเอียดของการสั่งซื้อ ใช้ AsyncValue เพื่อจัดการสถานะ loading, success, หรือ error. */
    @Default(AsyncValue.loading()) AsyncValue<OrderResponse?> orderDetail,
    /*เก็บรายการการสั่งซื้อทั้งหมด ใช้ AsyncValue เช่นเดียวกัน. */
    @Default(AsyncValue.loading()) AsyncValue<List<OrderResponse>?> orderList,
    /*เก็บจำนวนสินค้าที่สั่งซื้อ*/
    Map<String, int>? quantity,
/*เก็บวันที่และเวลาที่ทำการโอนเงิน.*/
    String? bankTransferDateTime,
    /* เก็บสถานะที่บอกว่าได้ทำการรีวิวแล้วหรือไม่*/
    @Default(false) bool isAlreadyReview,
  }) = _OrderState; /* ชื่อคลาสที่ถูกสร้างโดย Freezed */
}
