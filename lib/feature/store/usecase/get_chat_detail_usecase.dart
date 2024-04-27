import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

final getChatDetailUsecaseProvider = Provider<GetChatDetailUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return GetChatDetailUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class GetChatDetailUsecase
    extends UseCase<ChatWithPharmacyRequest, ChatWithPharmacyResponse> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  GetChatDetailUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<ChatWithPharmacyResponse> exec(
    ChatWithPharmacyRequest request,
  ) async {
    try {
      //ในกระบวนการดึงข้อมูล, ใช้ `fireCloudStore.collection('chat').where(...).get()`
      //เพื่อดึงข้อมูลการแชทที่มีสถานะ "approve" สำหรับผู้ใช้งานที่เป็นลูกค้า
      //หรือ "approve" หรือ "waiting" สำหรับผู้ใช้งานที่เป็นร้านขายยา
      final role = baseSharePreference.getString(BaseSharePreferenceKey.role);
      final pharmacyId = request.pharmacyId ?? '';

      final uid = request.uid ?? '';

      final collectChat = await fireCloudStore
          .collection('chat')
          .where('uid', isEqualTo: uid)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where(
            'status',
            isEqualTo: "approve",
          )
          .get()
          .then((value) => value.docs);
      //วนลูปเพื่อดึงข้อมูลแชทที่ได้มา
      for (final item in collectChat) {
        final _data = item.data() as Map<String, dynamic>;
        //ดึงข้อมูลผู้ใช้งานและข้อมูลร้านขายจาก Firebase Cloud Firestore
        DocumentSnapshot<Object?>? collectUser;
        DocumentSnapshot<Object?>? collectPharmacyStore;

        if (role == AuthenticationType.pharmacy.name) {
          collectUser = await fireCloudStore
              .collection('user')
              .doc(_data['uid'])
              .get()
              .then((value) => value);
        } else {
          collectUser = await fireCloudStore
              .collection('user')
              .doc(_data['pharmacyId'])
              .get()
              .then((value) => value);
          collectPharmacyStore = await fireCloudStore
              .collection('pharmacyStore')
              .doc(_data['pharmacyId'])
              .get()
              .then((value) => value);
        }
        //สร้าง `ChatWithPharmacyResponse` จากข้อมูลที่ได้
        return ChatWithPharmacyResponse(
          id: _data['id'],
          uid: _data['uid'],
          pharmacyId: _data['pharmacyId'],
          profileImg: collectUser?['profileImg'],
          nameStore: collectPharmacyStore?['nameStore'],
          licensePharmacy: collectPharmacyStore?['licensePharmacy'],
          phoneStore: collectPharmacyStore?['phoneStore'],
          fullName: collectUser?['fullName'],
          phone: collectUser?['phone'],
          chatImg: _data['chatImg'],
          message: _data['message'],
          createAt: (_data['create_at'] as Timestamp).toDate(),
          updateAt: (_data['update_at'] as Timestamp).toDate(),
          allergy: collectUser?['allergy'],
        );
      }
      //ถ้าไม่พบข้อมูลการแชทที่มีสถานะ "approve" สำหรับผู้ใช้งานนั้น ส่งค่าเริ่มต้นกลับ
      return const ChatWithPharmacyResponse();
    } catch (e) {
      return const ChatWithPharmacyResponse();
    }
  }
}
