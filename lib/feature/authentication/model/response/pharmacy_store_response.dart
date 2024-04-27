import 'package:freezed_annotation/freezed_annotation.dart';

part 'pharmacy_store_response.freezed.dart';
part 'pharmacy_store_response.g.dart';

@immutable
@freezed
abstract class PharmacyStoreResponse with _$PharmacyStoreResponse {
  @JsonSerializable()
  const factory PharmacyStoreResponse({
    String? uid,
    String? address,
    String? licensePharmacy,
    String? licensePharmacyImg,
    String? storeImg,
    String? nameStore,
    String? phoneStore,
    double? latitude,
    double? longtitude,
    String? timeOpening,
    String? timeClosing,
    String? licenseStore,
    String? licenseStoreImg,
    String? qrCodeImg,
    int? countReviewer,
    double? ratingScore,
    String? status,
    DateTime? update_at,
    DateTime? create_at,
  }) = _PharmacyStoreResponse;

  factory PharmacyStoreResponse.fromJson(Map<String, dynamic> json) =>
      _$PharmacyStoreResponseFromJson(json);
}
