import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';

final getMedicineWarehouseUsecaseProvider =
    Provider<GetMedicineWarehouseUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return GetMedicineWarehouseUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharePreference,
  );
});

class GetMedicineWarehouseUsecase
    extends UseCase<void, List<MedicineResponse>> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharePreference;

  GetMedicineWarehouseUsecase(
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
      //ในกระบวนการดึงข้อมูล, ใช้ `fireCloudStore.collection('medicineWarehouse').where('uid', isEqualTo: uid).get()`
      //เพื่อดึงข้อมูลรายการยาทั้งหมดที่เกี่ยวข้องกับผู้ใช้ที่ล็อกอินอยู่
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        final collectMedicine = await fireCloudStore
            .collection('medicineWarehouse')
            .where(
              'uid',
              isEqualTo: uid,
            )
            .get()
            .then((value) => value.docs);
        //วนลูปเพื่อดึงข้อมูลรายการยา
        List<MedicineResponse> medicineList = [];

        for (final item in collectMedicine) {
          final _data = item.data() as Map<String, dynamic>;
          //สร้าง `MedicineResponse` จากข้อมูลที่ได้
          medicineList.add(
            MedicineResponse(
              id: _data['id'],
              uid: _data['uid'],
              name: _data['name'],
              price: _data['price'],
              size: _data['size'],
              material: _data['material'],
              medicineImg: _data['medicineImg'],
            ),
          );
        }

        return medicineList;
      }
      return const [];
    } catch (e) {
      return const [];
    }
  }
}
