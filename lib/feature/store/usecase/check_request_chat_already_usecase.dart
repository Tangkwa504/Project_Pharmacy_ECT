import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';

final checkRequestChatAlreadyUsecaseProvider =
    Provider<CheckRequestChatAlreadyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return CheckRequestChatAlreadyUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class CheckRequestChatAlreadyUsecase
    extends UseCase<ChatWithPharmacyRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  CheckRequestChatAlreadyUsecase(
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
      //ดึงค่าพารามิเตอร์จากอ็อบเจ็กต์ request
      final pharmacyId = request.pharmacyId ?? '';

      //ดึง User ID จาก shared preferences
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      //ทำ Firestore query เพื่อตรวจสอบคำขอแชทที่มีอยู่แล้ว
      final hasRequest = await fireCloudStore
          .collection('chat')
          .where('uid', isEqualTo: uid)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where(
            'status',
            isEqualTo: "approve",
          )
          .get()
          .then((value) => value.docs);

      //คืนค่า true ถ้ามีคำขอแชทที่ผ่านเงื่อนไขทั้งหมด มิฉะนั้นคืนค่า false
      return hasRequest.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
