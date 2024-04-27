import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

final getHistoryOfChatPharmacyUsecaseProvider =
    Provider<GetHistoryOfChatPharmacyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return GetHistoryOfChatPharmacyUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class GetHistoryOfChatPharmacyUsecase
    extends UseCase<void, List<ChatWithPharmacyResponse>> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  GetHistoryOfChatPharmacyUsecase(
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
      //ในกระบวนการดึงข้อมูล, ใช้ `fireCloudStore.collection('chat').where('status', isEqualTo: 'approve').where('pharmacyId', isEqualTo: uid).orderBy('update_at').get()`
      //เพื่อดึงข้อมูลการแชททั้งหมดที่อนุมัติและเกี่ยวข้องกับร้านขายยา
      //และจัดเรียงตามวันที่อัปเดตล่าสุด (update_at)
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      final collect = await fireCloudStore
          .collection('chat')
          .where('status', isEqualTo: 'approve')
          .where(
            'pharmacyId',
            isEqualTo: uid,
          )
          .orderBy('update_at')
          .get()
          .then((value) => value.docs);

      //วนลูปเพื่อดึงข้อมูลประวัติการแชท
      List<ChatWithPharmacyResponse> requestChatList = [];

      for (final item in collect.reversed) {
        final _data = item.data() as Map<String, dynamic>;
        //ดึงข้อมูลผู้ใช้งานจาก Firebase Cloud Firestore
        final collectUser = await fireCloudStore
            .collection('user')
            .where(
              'uid',
              isEqualTo: _data['uid'],
            )
            .get()
            .then((value) => value.docs);

        final _user = collectUser.first.data() as Map<String, dynamic>;

        //ดึงข้อมูลล่าสุดจากการแชท
        final collectMessage = await fireCloudStore
            .collection('chat')
            .doc(_data['id'])
            .collection('chat_message')
            .orderBy('update_at')
            .get()
            .then((value) => value.docs);

        Map<String, dynamic>? _message;
        if (collectMessage.isNotEmpty) {
          _message = collectMessage.last.data();
        }
        //สร้าง `ChatWithPharmacyResponse` จากข้อมูลที่ได้
        requestChatList.add(
          ChatWithPharmacyResponse(
            id: _data['id'],
            uid: _data['uid'],
            pharmacyId: _data['pharmacyId'],
            profileImg: _user['profileImg'],
            fullName: _user['fullName'],
            phone: _user['phone'],
            chatImg: "ไฟล์รูปภาพ",
            message: _message?['message'] ?? '',
            isOnline: _user['isOnline'],
            createAt: (_data['create_at'] as Timestamp).toDate(),
            updateAt: (_data['update_at'] as Timestamp).toDate(),
            allergy: _user['allergy'],
          ),
        );
      }

      return requestChatList;
    } catch (e) {
      return [];
    }
  }
}
