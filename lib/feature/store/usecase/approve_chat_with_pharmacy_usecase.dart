import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';

final approveChatWithPharmacyUsecaseProvider =
    Provider<ApproveChatWithPharmacyUsecase>((ref) {
    //ดึง dependencies ที่จำเป็น
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return ApproveChatWithPharmacyUsecase(
    //สร้างและคืน instance ของ UseCase
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class ApproveChatWithPharmacyUsecase
    extends UseCase<ChatWithPharmacyRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  ApproveChatWithPharmacyUsecase(
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
      //ดึงข้อมูลที่จำเป็นจาก ChatWithPharmacyRequest
      final id = request.id ?? '';
      final isApprove = request.isApprove ?? false;

      //สร้าง collection ของ chat ใน Firebase Cloud Firestore
      final collect = fireCloudStore.collection('chat');

      //กำหนดข้อมูลที่จะปรับปรุงในเอกสาร chat ที่มี id ตามที่ระบุ
      final Map<String, dynamic> myData = {
        "status": isApprove ? "approve" : "cancel",
        "update_at": DateTime.now(),
      };

      //อัปเดตข้อมูลใน Firebase Cloud Firestore
      await collect.doc(id).update(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
