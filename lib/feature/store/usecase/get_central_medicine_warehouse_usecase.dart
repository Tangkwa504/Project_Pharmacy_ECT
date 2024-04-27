import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';

final getCentralMedicineWarehouseUsecaseProvider =
    Provider<GetCentralMedicineWarehouseUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return GetCentralMedicineWarehouseUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharePreference,
  );
});

class GetCentralMedicineWarehouseUsecase
    extends UseCase<void, List<MedicineResponse>> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharePreference;

  GetCentralMedicineWarehouseUsecase(
    Ref ref,
    this.fireCloudStore,
    this.firebaseCloudStorage,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<List<MedicineResponse>> exec(
    void request,
  ) async {
    try {
      //ในกระบวนการดึงข้อมูล,เพื่อดึงข้อมูลยาที่เป็นคลังกลางจาก Firebase Cloud Firestore.
      final collectMedicine = await fireCloudStore
          .collection('medicineWarehouse')
          .where(
            'isCentral',
            isEqualTo: true,
          )
          .get()
          .then((value) => value.docs);

      //สร้าง List เพื่อเก็บข้อมูลยาที่ดึงมา
      List<MedicineResponse> medicineList = [];
      //วนลูปเพื่อดึงข้อมูลแต่ละรายการแล้วเพิ่มเข้า List
      for (final item in collectMedicine) {
        final _data = item.data() as Map<String, dynamic>;

        medicineList.add(
          MedicineResponse(
            id: _data['id'],
            uid: _data['uid'],
            name: _data['name'],
            price: _data['price'],
            material: _data['material'],
            size: _data['size'],
            medicineImg: _data['medicineImg'],
          ),
        );
      }
      //ส่ง List ข้อมูลยากลับไป
      return medicineList;
    } catch (e) {
      return const [];
    }
  }
}
