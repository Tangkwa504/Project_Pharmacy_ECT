import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';

final updateNotificationUsecaseProvider =
    Provider<UpdateNotificationUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return UpdateNotificationUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class UpdateNotificationUsecase extends UseCase<String, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  UpdateNotificationUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    String id,
  ) async {
    try {
      final collect = fireCloudStore.collection('notification');  //ดึงข้อมูลจาก firebase ในคอนเลคชั่น notification มาใส่ในตัวแปร collect

      final Map<String, dynamic> myData = {
        "isRead": true,
      };

      await collect.doc(id).update(myData); //เป็นการอัพเดทข้อมูลแทนที่ของเก่าเลย

      return true;
    } catch (e) {
      return true;
    }
  }
}
