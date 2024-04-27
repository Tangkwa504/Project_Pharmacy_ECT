import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/medicine_request.dart';

final addCentralMedicineToMyWarehouseUsecaseProvider =
    Provider<AddCentralMedicineToMyWarehouseUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return AddCentralMedicineToMyWarehouseUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class AddCentralMedicineToMyWarehouseUsecase
    extends UseCase<MedicineRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  AddCentralMedicineToMyWarehouseUsecase(
    Ref ref,
    this.fireCloudStore,
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
      final medicineImg = request.currentMedicineImg;
      final size = request.size ?? '';
      final material = request.material ?? '';

      //ดึง uid ของผู้ใช้จาก SharedPreferences
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      //สร้าง collection ใน Firebase Cloud Firestore
      final collect = fireCloudStore.collection('medicineWarehouse');
      final collectId = collect.doc().id;

      //กำหนดข้อมูลที่จะเพิ่มลงในคลัง
      final Map<String, dynamic> myData = {
        "id": collectId,
        "uid": uid,
        "name": name,
        "price": price,
        "medicineImg": medicineImg,
        "size": size,
        "material": material,
        "isCentral": false,
        "create_at": DateTime.now(),
        "update_at": DateTime.now(),
      };

      //เพิ่มข้อมูลลงในคลัง
      await collect.doc(collectId).set(myData);

      //สำเร็จและคืนค่า true
      return true;
    } catch (e) {
      return false;
    }
  }
}
