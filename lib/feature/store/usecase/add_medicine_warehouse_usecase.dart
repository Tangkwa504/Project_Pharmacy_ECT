import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/store/model/request/medicine_request.dart';

final addMedicineWarehouseUsecaseProvider =
    Provider<AddMedicineWarehouseUsecase>((ref) {
  //ดึง dependencies ที่จำเป็น
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);

  //สร้างและคืน instance ของ UseCase
  return AddMedicineWarehouseUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharePreference,
  );
});

class AddMedicineWarehouseUsecase extends UseCase<MedicineRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharePreference;

  AddMedicineWarehouseUsecase(
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
      //ดึงข้อมูลที่จำเป็นจาก MedicineRequest
      final name = request.name ?? '';
      final price = request.price ?? 0.0;
      final medicineImg = request.medicineImg;
      final material = request.material ?? '';
      final size = request.size ?? '';

      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);
      final isAdmin =
          baseSharePreference.getString(BaseSharePreferenceKey.role) ==
              AuthenticationType.admin.name;

      if (uid != null) {
        String urlMedicineImg = '';

        //อัปโหลดรูปภาพของยาไปยัง Firebase Cloud Storage (ถ้ามี)
        if (medicineImg != null) {
          urlMedicineImg = await firebaseCloudStorage.uploadStorage(
            medicineImg,
            'medicineWarehouse/$uid',
          );
        }
        //สร้าง collection ของ medicineWarehouse ใน Firebase Cloud Firestore
        final collect = fireCloudStore.collection('medicineWarehouse');
        final id = collect.doc().id;
        //กำหนดข้อมูลที่จะเพิ่มลงใน medicineWarehouse
        final Map<String, dynamic> myData = {
          "id": id,
          "uid": uid,
          "name": name,
          "price": price,
          "medicineImg": urlMedicineImg,
          "material": material,
          "size": size,
          "isCentral": isAdmin ? true : false,
          "create_at": DateTime.now(),
          "update_at": DateTime.now(),
        };
        //เพิ่ม medicineWarehouse ลงใน Firebase Cloud Firestore
        await collect.doc(id).set(myData);
        //สำเร็จและคืนค่า true
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
