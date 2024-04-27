import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/auth/auth_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  //รับ dependency จาก Provider ต่างๆ
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  //สร้างและคืนค่า instance ของ LogoutUsecase
  return LogoutUsecase(
    ref,
    firebaseAuth,
    fireCloudStore,
    baseSharedPreference,
  );
});

class LogoutUsecase extends UseCase<void, bool> {
  final FirebaseAuthProvider firebaseAuthProvider;
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  LogoutUsecase(
    Ref ref,
    this.firebaseAuthProvider,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    void request,
  ) async {
    try {
      //ดึงข้อมูล uid จาก SharedPreferences
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);
      //ถ้า uid ไม่ใช่ค่าว่าง 
      if (uid != null) {
        //เรียกใช้ฟังชั่นออกจากระบบ จาก firebaseAuthProvider
        await firebaseAuthProvider.signOut();
        
        //อัปเดตข้อมูลใน Firestore เพื่อกำหนดสถานะ isOnline เป็น false
        final collect = fireCloudStore.collection('user');
        await collect.doc(uid).update(
          {
            "isOnline": false,
          },
        );

        //ลบข้อมูลจาก SharedPreferences
        await baseSharedPreference.remove(
          BaseSharePreferenceKey.userId,
        );
        await baseSharedPreference.remove(
          BaseSharePreferenceKey.role,
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
