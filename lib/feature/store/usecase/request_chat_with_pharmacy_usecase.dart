import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';

final requestChatWithPharmacyUsecaseProvider =
    Provider<RequestChatWithPharmacyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return RequestChatWithPharmacyUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class RequestChatWithPharmacyUsecase
    extends UseCase<ChatWithPharmacyRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  RequestChatWithPharmacyUsecase(
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
      //ดึงข้อมูลที่จำเป็นในการสร้างคำขอแชท
      final pharmacyId = request.pharmacyId ?? '';

      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);
      //ในกระบวนการสร้างคำขอแชท, ใช้ `fireCloudStore.collection('chat')` เพื่อสร้างเอกสารใหม่ที่จะเก็บข้อมูลของคำขอแชทใหม่
      final collect = fireCloudStore.collection('chat');

      final collectId = collect.doc().id;
      //สร้างข้อมูลที่จะบันทึกลงในคอลเล็กชัน 'chat'
      final Map<String, dynamic> myData = {
        "id": collectId,
        "uid": uid,
        "pharmacyId": pharmacyId,
        "status": "waiting",
        "create_at": DateTime.now(),
        "update_at": DateTime.now(),
      };
      //บันทึกข้อมูลลงในคอลเล็กชัน 'chat'
      await collect.doc(collectId).set(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
