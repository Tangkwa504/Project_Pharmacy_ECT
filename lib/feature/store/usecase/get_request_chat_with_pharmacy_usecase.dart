import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

final getGetRequestChatWithPharmacyUsecaseProvider =
    Provider<GetRequestChatWithPharmacyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return GetRequestChatWithPharmacyUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class GetRequestChatWithPharmacyUsecase
    extends UseCase<void, List<ChatWithPharmacyResponse>> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  GetRequestChatWithPharmacyUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<List<ChatWithPharmacyResponse>> exec(
    void request,
  ) async {
    try {
      //ในกระบวนการดึงข้อมูล, ใช้ `fireCloudStore.collection('chat')`
      //เพื่อดึงข้อมูลคำขอแชทที่มี `status` เป็น "waiting" และ `pharmacyId` เป็น uid ของผู้ใช้ปัจจุบัน
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      final collect = await fireCloudStore
          .collection('chat')
          .where('status', isEqualTo: 'waiting')
          .where(
            'pharmacyId',
            isEqualTo: uid,
          )
          .orderBy('create_at')
          .get()
          .then((value) => value.docs);

      List<ChatWithPharmacyResponse> requestChatList = [];
      //วนลูปเพื่อดึงข้อมูลของแต่ละคำขอแชทที่ยังไม่ได้ตอบรับ
      for (final item in collect.reversed) {
        final _data = item.data() as Map<String, dynamic>;

        //ในแต่ละคำขอแชท, ใช้ `fireCloudStore.collection('user')` เพื่อดึงข้อมูลผู้ใช้ที่เป็นผู้ส่งคำขอแชทนี้
        final collectUser = await fireCloudStore
            .collection('user')
            .where(
              'uid',
              isEqualTo: _data['uid'],
            )
            .get()
            .then((value) => value.docs);

        final _user = collectUser.first.data() as Map<String, dynamic>;

        //สร้าง `ChatWithPharmacyResponse` จากข้อมูลที่ได้
        requestChatList.add(
          ChatWithPharmacyResponse(
            id: _data['id'],
            uid: _data['uid'],
            profileImg: _user['profileImg'],
            fullName: _user['fullName'],
            phone: _user['phone'],
            createAt: (_data['create_at'] as Timestamp).toDate(),
          ),
        );
      }

      return requestChatList;
    } catch (e) {
      return [];
    }
  }
}
