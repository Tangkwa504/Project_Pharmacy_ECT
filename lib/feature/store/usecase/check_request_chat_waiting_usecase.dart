import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';

final checkRequestChatWaitingUsecaseProvider =
    Provider<CheckRequestChatWaitingUsecase>((ref) {
    //ประกาศ Provider สำหรับ Use Case ดึงรายการของ dependencies ที่จำเป็นจาก Riverpod
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  //คืนค่า instance ของ use case พร้อม dependencies ที่ถูก Inject
  return CheckRequestChatWaitingUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class CheckRequestChatWaitingUsecase
    extends UseCase<ChatWithPharmacyRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  CheckRequestChatWaitingUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ChatWithPharmacyRequest request,
  ) async {
    try {
       //ดึงพารามิเตอร์จาก request
      final pharmacyId = request.pharmacyId ?? '';

      //ดึง user ID จาก shared preferences
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      //ทำ Firestore query เพื่อตรวจสอบคำขอแชทที่รอดำเนินการ
      final hasRequest = await fireCloudStore
          .collection('chat')
          .where('uid', isEqualTo: uid)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where(
            'status',
            isEqualTo: "waiting",
          )
          .get()
          .then((value) => value.docs);

      //คืนค่า true หากมีคำขอแชทที่รอดำเนินการที่ผ่านเงื่อนไขทั้งหมด ถ้าไม่ใช่คืนค่า false
      return hasRequest.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
