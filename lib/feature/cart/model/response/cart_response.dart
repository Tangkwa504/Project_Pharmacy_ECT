import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';

part 'cart_response.freezed.dart';
part 'cart_response.g.dart';

@immutable
@freezed
abstract class CartResponse with _$CartResponse {
  @JsonSerializable()
  const factory CartResponse({
    String? id,
    String? pharmacyId,
    String? cartNumber,
    String? uid,
    String? nameStore,
    String? fullName,
    String? phone,
    String? address,
    String? district,
    String? subDistrict,
    String? province,
    String? postNumber,
    String? vatFee,
    String? deliveryFee,
    String? totalPrice,
    String? sumamryPrice,
    List<MedicineResponse>? medicineList,
    OrderStatus? status,
    DateTime? createAt,
    DateTime? updateAt,
  }) = _CartResponse;

  factory CartResponse.fromJson(Map<String, dynamic> json) =>
      _$CartResponseFromJson(json);
}
