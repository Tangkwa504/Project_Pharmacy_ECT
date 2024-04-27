import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/home/model/response/notification_response.dart';

final getNotificationUsecaseProvider = Provider<GetNotificationUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return GetNotificationUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class GetNotificationUsecase extends UseCase<void, List<NotificationResponse>> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  GetNotificationUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<List<NotificationResponse>> exec(
    void request,
  ) async {
    try {
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      final collect = await fireCloudStore
          .collection('notification')
          .where('uid', isEqualTo: uid)
          .orderBy('create_at')
          .get()
          .then((value) => value.docs);

      List<NotificationResponse> notificationList = [];

      for (final item in collect.reversed) {
        final _data = item.data() as Map<String, dynamic>;

        notificationList.add(//เป็นการเพิ่มข้อมูลในคอลเลคชั่น
          NotificationResponse(
            id: _data['id'],
            uid: _data['uid'],
            message: _data['message'],
            status: _data['status'],
            isRead: _data['isRead'],
            createAt: (_data['create_at'] as Timestamp).toDate(),
          ),
        );
      }

      return notificationList;
    } catch (e) {
      return [];
    }
  }
}
