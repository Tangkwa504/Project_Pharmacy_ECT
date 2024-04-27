import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/model/request/user_info_request.dart';

final updatePharmacyStoreUsecaseProvider =
    Provider<UpdatePharmacyStoreUsecase>((ref) {
  //รับ dependency จาก Provider ต่างๆ
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return UpdatePharmacyStoreUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharedPreference,
  );
});

class UpdatePharmacyStoreUsecase extends UseCase<UserInfoRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharedPreference;

  UpdatePharmacyStoreUsecase(
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
      final address = request.address;
      final licensePharmacy = request.licensePharmacy ?? '';
      final nameStore = request.nameStore ?? '';
      final currentStoreImg = request.currentStoreImg ?? '';
      final phoneStore = request.phoneStore ?? '';
      final latitude = request.latitude ?? 0.0;
      final longtitude = request.longtitude ?? 0.0;
      final timeOpening = request.timeOpening ?? '';
      final timeClosing = request.timeClosing ?? '';
      final licenseStore = request.licenseStore ?? '';
      final licenseStoreImg = request.licenseStoreImg;
      final currentLicenseStoreImg = request.currentLicenseStoreImg;
      final storeImg = request.storeImg;

      //ดึง uid จาก SharedPreferences
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      //ถ้า uid ไม่ใช่ค่าว่าง
      if (uid != null) {
        String urlLicenseStoreImg = '';
        String urlStoreImg = '';

        //ทำการอัปโหลดรูป storeImg ลงใน Firebase Storage
        if (storeImg != null) {
          urlStoreImg = await firebaseCloudStorage.uploadStorage(
            storeImg,
            'pharmacyStore/$uid',
          );
        }
        //ทำการอัปโหลดรูป licenseStoreImg ลงใน Firebase Storage
        if (licenseStoreImg != null) {
          urlLicenseStoreImg = await firebaseCloudStorage.uploadStorage(
            licenseStoreImg,
            'pharmacyStore/$uid',
          );
        }

        //นำข้อมูลที่ได้อัปโหลดและข้อมูลปัจจุบันมากำหนดค่า
        final collectPharmacyStore = fireCloudStore.collection('pharmacyStore');

        final Map<String, dynamic> myData = {
          "uid": uid,
          "nameStore": nameStore,
          "address": address,
          "licensePharmacy": licensePharmacy,
          "phoneStore": phoneStore,
          "latitude": latitude,
          "longtitude": longtitude,
          "status": "waiting",
          "timeOpening": timeOpening,
          "timeClosing": timeClosing,
          "licenseStore": licenseStore,
          "licenseStoreImg": licenseStoreImg != null
              ? urlLicenseStoreImg
              : currentLicenseStoreImg,
          "storeImg": storeImg != null ? urlStoreImg : currentStoreImg,
          "update_at": DateTime.now(),
        };

        //ทำการอัปเดตข้อมูลใน Firestore
        await collectPharmacyStore.doc(uid).update(
              myData,
            );

        final collectUser = fireCloudStore.collection('user');
        //นำข้อมูลที่ได้อัปโหลดและข้อมูลปัจจุบันมากำหนดค่า
        final Map<String, dynamic> myDataUser = {
          "status": "waiting",
          "update_at": DateTime.now(),
        };
        //ทำการอัปเดตข้อมูลใน Firestore
        await collectUser.doc(uid).update(
              myDataUser,
            );

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
