import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';

part 'cart_request.freezed.dart';
part 'cart_request.g.dart';

@immutable
@freezed
abstract class CartRequest with _$CartRequest {
  @JsonSerializable()
  const factory CartRequest({
    String? id,
    @Default(false) bool isPharmacy,
    String? cartNumber,
    String? storeId,
    String? pharmacyId,
    String? uid,
    String? fullName,
    String? nameStore,
    String? phone,
    String? address,
    String? district,
    String? subDistrict,
    String? province,
    String? postNumber,
    String? vatFee,
    String? deliveryFee,
    String? totalPrice,
    String? summaryPrice,
    int? quantity,
    String? medicineId,
    String? medicineImg,
    double? medicinePrice,
    String? medicineName,
    String? medicineSize,
    String? medicineMaterial,
    OrderStatus? status,
    String? cartMedicineId,
  }) = _CartRequest;

  factory CartRequest.fromJson(Map<String, dynamic> json) =>
      _$CartRequestFromJson(json);
}
