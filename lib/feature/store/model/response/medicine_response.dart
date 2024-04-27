import 'package:freezed_annotation/freezed_annotation.dart';

part 'medicine_response.freezed.dart';
part 'medicine_response.g.dart';

@immutable
@freezed
abstract class MedicineResponse with _$MedicineResponse {
  @JsonSerializable()
  const factory MedicineResponse({
    String? id,
    String? uid,
    String? medicineImg,
    String? name,
    double? price,
    int? quantity,
    String? howToUse,
    String? cartMedicineId,
    String? purePrice,
    String? size,
    String? material,
  }) = _MedicineResponse;

  factory MedicineResponse.fromJson(Map<String, dynamic> json) =>
      _$MedicineResponseFromJson(json);
}
