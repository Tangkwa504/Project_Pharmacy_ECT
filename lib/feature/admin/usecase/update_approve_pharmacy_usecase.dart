import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/feature/admin/model/request/approve_request.dart';

// Provider สำหรับให้ Consumer สามารถเรียกใช้ UpdateApprovePharmacyUsecase ได้
final updateApprovePharmacyUsecaseProvider =
    Provider<UpdateApprovePharmacyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);

  return UpdateApprovePharmacyUsecase(
    ref,
    fireCloudStore,
  );
});

class UpdateApprovePharmacyUsecase extends UseCase<ApproveRequest, bool> {
  final FirebaseCloudStore fireCloudStore;

  UpdateApprovePharmacyUsecase(
    Ref ref,
    this.fireCloudStore,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ApproveRequest request,
  ) async {
    try {
      // ดึงคอลเลคชันข้อมูลผู้ใช้และร้านเภสัชกร
      final collectUser = fireCloudStore.collection('user');
      final collectPharmacyStore = fireCloudStore.collection('pharmacyStore');

      final isWarning = request.isWarning;

      if (isWarning) {
        await collectUser.doc(request.uid).update({'status': 'waitingEdit'});
        await collectPharmacyStore
            .doc(request.uid)
            .update({'status': 'waitingEdit'});
      } else {
        // อัปเดตสถานะของผู้ใช้และร้านเภสัชกรตามคำขอ
        await collectUser
            .doc(request.uid)
            .update({'status': request.isApprove ? 'approve' : 'cancel'});
        await collectPharmacyStore
            .doc(request.uid)
            .update({'status': request.isApprove ? 'approve' : 'cancel'});
      }

      // คืนค่า true หากปรับปรุงข้อมูลสำเร็จ
      return true;
    } catch (e) {
      // คืนค่า false หากเกิดข้อผิดพลาดในการปรับปรุงข้อมูล
      return false;
    }
  }
}
