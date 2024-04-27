import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/feature/authentication/model/response/pharmacy_store_response.dart';
import 'package:pharmacy_online/feature/authentication/model/response/user_info_response.dart';

part 'profile_state.freezed.dart'; // กำหนดคลาส `ProfileState` เป็นคลาสแบบ Freezed

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    BaseFormData? baseFormData, // ข้อมูลฟอร์ม
    String? errMsg, // ข้อความแสดงข้อผิดพลาด
    UserInfoResponse? userInfo, // ข้อมูลผู้ใช้
    PharmacyStoreResponse? pharmacyStore, // ข้อมูลร้านค้า (สำหรับเภสัชกร)
    @Default(false) bool isPharmacy, // สถานะผู้ใช้ (เภสัชกรหรือลูกค้า)
    double? latitudeUser, // ละติจูดและลองจิจูดของผู้ใช้
    double? longtitudeUser,
    double? latitudeStore, // ละติจูดและลองจิจูดของร้านค้า (สำหรับเภสัชกร)
    double? longtitudeStore,
  }) = _ProfileState;
}
