import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';

// ใช้ Freezed Annotation เพื่อสร้าง State แบบ Immutable (ไม่สามารถแก้ไขค่าได้ตรงๆ) 
part 'admin_state.freezed.dart';

@freezed
class AdminState with _$AdminState {
  // สร้าง State สำหรับการจัดการข้อมูลร้านขายยา
  const factory AdminState({
    // ใช้ AsyncValue สำหรับจัดการ State ที่เป็น asynchronous
    @Default(AsyncValue.loading())
    AsyncValue<List<PharmacyInfoResponse>?> pharmacyInfoList,
  }) = _AdminState;
}
