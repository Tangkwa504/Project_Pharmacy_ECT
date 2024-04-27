import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/authentication/model/response/user_info_response.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';

final getUserInfoUsecaseProvider = Provider<GetUserInfoUseCase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);
  final baseUtils = ref.watch(baseUtilsProvider);

  return GetUserInfoUseCase(
    ref,
    fireCloudStore,
    baseSharedPreference,
    baseUtils,
  );
});

// สร้าง UseCase สำหรับการดึงข้อมูลของผู้ใช้
class GetUserInfoUseCase extends UseCase<void, UserInfoResponse> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;
  final BaseUtils baseUtils;

  // กำหนด Constructor พร้อมรับ Provider ที่ต้องใช้
  GetUserInfoUseCase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
    this.baseUtils,
  ) {
    this.ref = ref;
  }

  // ฟังก์ชัน exec ในการดึงข้อมูลของผู้ใช้
  @override
  Future<UserInfoResponse> exec(
    void request,
  ) async {
    try {
      // ดึงข้อมูล uid จาก SharedPreferences
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        // ดึง Collection ของ user
        final collect = fireCloudStore.collection('user');

        // ดึงข้อมูลจาก Firestore ด้วย uid
        final data = await collect
            .doc(
              uid,
            )
            .get()
            .then((value) => value.data() as Map<String, dynamic>);

        // อัปเดตข้อมูล isOnline ใน Firestore
        await collect.doc(uid).update(
          {
            "isOnline": true,
          },
        );

        // อัปเดตข้อมูลบางส่วนใน SharedPreferences
        await baseSharedPreference.setString(
          BaseSharePreferenceKey.role,
          data['role'],
        );

        // ตรวจสอบ rold ของผู้ใช้และสร้าง UserInfoResponse ตามเงื่อนไข
        if (data['role'] == AuthenticationType.admin.name) {
          return UserInfoResponse(
            uid: data['uid'],
            role: data['role'],
          );
        }

        return UserInfoResponse(
          uid: data['uid'],
          email: data['email'],
          password: data['password'],
          role: data['role'],
          profileImg: data['profileImg'],
          fullName: data['fullName'],
          address: data['address'],
          phone: data['phone'],
          latitude: data['latitude'],
          longtitude: data['longtitude'],
          status: data['status'],
          create_at: (data['create_at'] as Timestamp).toDate(),
          allergy: data['allergy'],
        );
      }

      return const UserInfoResponse();
    } catch (e) {
      return const UserInfoResponse();
    }
  }
}
