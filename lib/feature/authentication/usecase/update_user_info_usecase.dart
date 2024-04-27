import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/authentication/model/request/user_info_request.dart';

final updateUserInfoUsecaseProvider = Provider<UpdateUserInfoUsecase>((ref) {
  //รับ dependency จาก Provider ต่างๆ
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);
  //สร้างและคืนค่า instance ของ UpdateUserInfoUsecase
  return UpdateUserInfoUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharedPreference,
  );
});

class UpdateUserInfoUsecase extends UseCase<UserInfoRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharedPreference;

  UpdateUserInfoUsecase(
    Ref ref,
    this.fireCloudStore,
    this.firebaseCloudStorage,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    UserInfoRequest request,
  ) async {
    try {
      //ดึงข้อมูลจาก request
      final role = request.role ?? '';
      final profileImg = request.profileImg;
      final currentProfileImg = request.currentProfileImg;
      final fullName = request.fullName ?? '';
      final address = request.address;
      final phone = request.phone ?? '';
      final latitude = request.latitude ?? 0.0;
      final longtitude = request.longtitude ?? 0.0;
      final licensePharmacyImg = request.licensePharmacyImg;
      final currentLicensePharmacyImg = request.currentLicensePharmacyImg;
      final licensePharmacy = request.licensePharmacy ?? '';
      final allergy = request.allergy;

      //ดึง uid จาก SharedPreferences
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      //ถ้า uid ไม่ใช่ค่าว่าง
      if (uid != null) {
        String urlProfileImage = '';
        String urlLicensePharmacyImg = '';

        //ทำการอัปโหลดรูป profileImg ลงใน Firebase Storage
        if (profileImg != null) {
          urlProfileImage = await firebaseCloudStorage.uploadStorage(
            profileImg,
            'user/$uid',
          );
        }
        //ทำการอัปโหลดรูป licensePharmacyImg ลงใน Firebase Storage
        if (licensePharmacyImg != null) {
          urlLicensePharmacyImg = await firebaseCloudStorage.uploadStorage(
            licensePharmacyImg,
            'pharmacy/$uid',
          );
        }

        //เรียกใช้ข้อมูล collection 'user'
        final collectUser = fireCloudStore.collection('user');
        //นำข้อมูลที่ได้อัปโหลดและข้อมูลปัจจุบันมากำหนดค่า
        final Map<String, dynamic> myData = {
          "profileImg":
              profileImg != null ? urlProfileImage : currentProfileImg,
          "fullName": fullName,
          "address": address,
          "phone": phone,
          "latitude": latitude,
          "longtitude": longtitude,
          "update_at": DateTime.now(),
          "allergy": allergy,
        };
        //ทำการอัปเดตข้อมูลใน Firestore
        await collectUser.doc(uid).update(
              myData,
            );

        //ถ้า role เป็น 'pharmacy' ทำการอัปเดตข้อมูลเพิ่มเติมใน 'pharmacyStore' collection
        if (role == AuthenticationType.pharmacy.name) {
          final collectPharmacyStore =
              fireCloudStore.collection('pharmacyStore');

          final Map<String, dynamic> myDataPharmacy = {
            "licensePharmacyImg": licensePharmacyImg != null
                ? urlLicensePharmacyImg
                : currentLicensePharmacyImg,
            "licensePharmacy": licensePharmacy,
            "update_at": DateTime.now(),
          };

          await collectPharmacyStore.doc(uid).update(myDataPharmacy);
        }

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
