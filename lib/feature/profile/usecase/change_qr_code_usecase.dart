import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';

final changeQRCodeUsecaseProvider = Provider<ChangeQRCodeUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return ChangeQRCodeUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharedPreference,
  );
});

// สร้าง UseCase สำหรับการเปลี่ยน QR Code
class ChangeQRCodeUsecase extends UseCase<XFile, bool> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharedPreference;

  // กำหนด Constructor พร้อมรับ Provider ที่ต้องใช้
  ChangeQRCodeUsecase(
    Ref ref,
    this.fireCloudStore,
    this.firebaseCloudStorage,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    XFile request,
  ) async {
    try {
      // ดึงข้อมูล uid จาก SharedPreferences
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        // อัปโหลดรูปภาพ QR Code ไปยัง Firebase Cloud Storage
        final urlQrCodeImg = await firebaseCloudStorage.uploadStorage(
          request,
          'qrCode/$uid',
        );

        // ดึง Collection ของ pharmacyStore
        final collectPharmacyStore = fireCloudStore.collection('pharmacyStore');

        // กำหนดข้อมูลที่ต้องการอัปเดต
        final Map<String, dynamic> myData = {
          "qrCodeImg": urlQrCodeImg,
          "update_at": DateTime.now(),
        };

        // ทำการอัปเดตข้อมูลใน Firestore
        await collectPharmacyStore.doc(uid).update(myData);

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
