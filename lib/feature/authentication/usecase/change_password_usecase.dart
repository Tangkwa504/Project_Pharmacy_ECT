import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/auth/auth_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/model/request/change_password_request.dart';

final changePasswordUsecaseProvider = Provider<ChangePasswordUsecase>((ref) {
  //รับ dependency จาก Provider ต่างๆ
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);

  return ChangePasswordUsecase(
    ref,
    firebaseAuth,
    baseSharedPreference,
    fireCloudStore,
  );
});

class ChangePasswordUsecase extends UseCase<ChangePasswordRequest, bool> {
  final FirebaseAuthProvider firebaseAuth;
  final BaseSharedPreference baseSharedPreference;
  final FirebaseCloudStore fireCloudStore;

  ChangePasswordUsecase(
    Ref ref,
    this.firebaseAuth,
    this.baseSharedPreference,
    this.fireCloudStore,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ChangePasswordRequest request,
  ) async {
    try {
      // เรียกใช้ changePassword จาก firebaseAuth ในการเปลี่ยนรหัสผ่าน
      final result = await firebaseAuth.changePassword(
        request.currentPassword,
        request.newPassword,
      );

      if (result) {
        // ถ้าการเปลี่ยนรหัสผ่านสำเร็จ ดึง userId จาก SharedPreferences
        final userId =
            baseSharedPreference.getString(BaseSharePreferenceKey.userId);
        // ดึง collection 'user' จาก Cloud Firestore
        final collect = fireCloudStore.collection('user');
        // กำหนดข้อมูลที่จะอัปเดต
        final Map<String, dynamic> myData = {
          "password": request.newPassword,
          "update_at": DateTime.now(),
        };
        // ทำการอัปเดตข้อมูลใน Firestore
        await collect.doc(userId).update(
              myData,
            );
      }

      return result;
    } catch (e) {
      return false;
    }
  }
}
