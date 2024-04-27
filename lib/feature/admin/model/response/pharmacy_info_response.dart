// ไฟล์นี้เป็นส่วนของ Dart ที่ใช้กับ Freezed และ JsonSerializable
// เพื่อสร้าง data class สำหรับจัดการข้อมูลที่มีการ serialize และ deserialize จาก JSON
import 'package:freezed_annotation/freezed_annotation.dart';

// สร้าง data class ที่ใช้ Freezed สำหรับการสร้าง union classes และค่า constructor
part 'pharmacy_info_response.freezed.dart';
// Import annotation JsonSerializable เพื่อให้ class นี้ได้รับการสนับสนุนจาก JsonSerializable Generator
part 'pharmacy_info_response.g.dart';

// ใช้ @freezed annotation เพื่อสร้าง union class และ constructor สำหรับการใช้งาน
@immutable
@freezed
abstract class PharmacyInfoResponse with _$PharmacyInfoResponse {
  // ในส่วนนี้คือการสร้าง constructor และให้ class _PharmacyInfoResponse เป็น implementation ของ PharmacyInfoResponse
  @JsonSerializable()
  const factory PharmacyInfoResponse({
    String? uid,
    String? email,
    String? password,
    String? role,
    String? profileImg,
    String? fullName,
    String? address,
    String? licensePharmacy,
    String? licensePharmacyImg,
    String? phone,
    String? addressStore,
    String? storeImg,
    String? nameStore,
    String? phoneStore,
    String? timeOpening,
    String? timeClosing,
    String? licenseStore,
    String? licenseStoreImg,
    String? status,
    double? latitude,
    double? longtitude,
    String? qrCode,
    int? countReviewer,
    double? ratingScore,
  }) = _PharmacyInfoResponse;

  // ใช้ factory method สำหรับการสร้าง object ของ class PharmacyInfoResponse จาก JSON
  factory PharmacyInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$PharmacyInfoResponseFromJson(json);
}
