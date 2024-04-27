import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/home/model/request/notification_request.dart';

final deleteNotificationUsecaseProvider =
    Provider<DeleteNotificationUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return DeleteNotificationUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class DeleteNotificationUsecase extends UseCase<NotificationRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  DeleteNotificationUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec( 
    NotificationRequest request,
  ) async {
    try {
      final id = request.id;

      final collect = fireCloudStore.collection('notification'); //ดึงข้อมูลจาก firebase ในคอนเลคชั่น notification มาใส่ในตัวแปร collect

      await collect.doc(id).delete(); //ลบ collect ที่ตรงกับ id

      return true;
    } catch (e) {
      return false;
    }
  }
}
