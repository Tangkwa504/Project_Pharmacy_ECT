import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

final getMessageChatUsecaseProvider = Provider<GetMessageChatUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);

  return GetMessageChatUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class GetMessageChatUsecase
    extends UseCase<ChatWithPharmacyRequest, List<ChatWithPharmacyResponse>> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  GetMessageChatUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<List<ChatWithPharmacyResponse>> exec(
    ChatWithPharmacyRequest request,
  ) async {
    try {
      //ดึงข้อมูล request.id หรือใช้ค่าว่างเป็นค่าเริ่มต้น
      final id = request.id ?? '';

        //ดึงข้อมูลทั้งหมดจาก Firestore ใน collection 'chat' -> document(id) -> collection 'chat_message'
      final collectMessage = await fireCloudStore
          .collection('chat')
          .doc(id)
          .collection('chat_message')
          .orderBy('create_at')
          .get()
          .then((value) => value.docs);
      ;

      List<ChatWithPharmacyResponse> requestChatList = [];
      
      //วนลูปเพื่อนำข้อมูลมาเก็บใน List ของ ChatWithPharmacyResponse
      for (final item in collectMessage) {
        final _data = item.data();

        requestChatList.add(
          ChatWithPharmacyResponse(
            uid: _data['uid'],
            profileImg: _data['profileImg'],
            chatImg: _data['chatImg'],
            message: _data['message'],
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
