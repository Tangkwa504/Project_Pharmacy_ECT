import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/medicine_request.dart';

final editMedicineWarehouseUsecaseProvider =
    Provider<EditMedicineWarehouseUsecase>((ref) {
  //editMedicineWarehouseUsecaseProvider คือ Provider ที่ให้บริการ `EditMedicineWarehouseUsecase` ซึ่งเป็น `UseCase` ที่ทำหน้าที่แก้ไขข้อมูลของยา
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return EditMedicineWarehouseUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharePreference,
  );
});

class EditMedicineWarehouseUsecase extends UseCase<MedicineRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharePreference;

  EditMedicineWarehouseUsecase(
    Ref ref,
    this.fireCloudStore,
    this.firebaseCloudStorage,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    MedicineRequest request,
  ) async {
    try {
      //ดึงข้อมูลที่ต้องการแก้ไขจาก `request`
      final id = request.id ?? '';
      final name = request.name ?? '';
      final price = request.price ?? 0.0;
      final medicineImg = request.medicineImg;
      final currentMedicineImg = request.currentMedicineImg;
      final material = request.material ?? '';
      final size = request.size ?? '';
      //ดึง uid จาก SharedPreferences
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        //ตรวจสอบว่ามีรูปภาพของยาใหม่หรือไม่ และทำการอัปโหลดในกรณีที่มีรูปภาพใหม่
        String urlMedicineImg = '';

        if (medicineImg != null) {
          urlMedicineImg = await firebaseCloudStorage.uploadStorage(
            medicineImg,
            'medicineWarehouse/$uid',
          );
        }

        //สร้าง collectUser ซึ่งเป็นคอลเลคชันของ Firebase Cloud Firestore ที่เกี่ยวข้องกับข้อมูลของยา
        final collectUser = fireCloudStore.collection('medicineWarehouse');
        //สร้าง Map ที่ประกอบด้วยข้อมูลที่ต้องการแก้ไข เช่น `name`, `price`, `medicineImg`, และ `update_at`
        final Map<String, dynamic> myData = {
          "name": name,
          "price": price,
          "medicineImg":
              medicineImg != null ? urlMedicineImg : currentMedicineImg,
          "material": material,
          "size": size,
          "update_at": DateTime.now(),
        };

        //ทำการอัปเดตข้อมูลของยาด้วย `collectUser.doc(id).update(myData)`
        await collectUser.doc(id).update(myData);

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
