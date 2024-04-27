import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/feature/store/model/request/medicine_request.dart';

final deleteMedicineWarehouseUsecaseProvider =
    Provider<DeleteMedicineWarehouseUsecase>((ref) {
      //deleteMedicineWarehouseUsecaseProvider คือ Provider ที่ให้บริการ `DeleteMedicineWarehouseUsecase` ซึ่งเป็น `UseCase` ที่ทำหน้าที่ลบข้อมูลยาจากคลังของร้าน
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  return DeleteMedicineWarehouseUsecase(
    ref,
    fireCloudStore,
  );
});

class DeleteMedicineWarehouseUsecase extends UseCase<MedicineRequest, bool> {
  final FirebaseCloudStore fireCloudStore;

  DeleteMedicineWarehouseUsecase(
    Ref ref,
    this.fireCloudStore,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    MedicineRequest request,
  ) async {
    try {
      //ดึง `id` ของยาที่ต้องการลบจาก `request`
      final id = request.id ?? '';

      //สร้าง `collectUser` ซึ่งเป็นคอลเลคชันของ Firebase Cloud Firestore ที่เกี่ยวข้องกับยา
      final collectUser = fireCloudStore.collection('medicineWarehouse');
      //ใช้ `collectUser.doc(id).delete()` เพื่อลบเอกสารที่มี `id` ที่ระบุ
      await collectUser.doc(id).delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
