import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';

final pushMessageChatUsecaseProvider = Provider<PushMessageChatUsecase>((ref) {
  //นำเข้า dependencies และ services ที่จะถูกใช้ใน usecase
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);

  return PushMessageChatUsecase(
    //สร้าง instance ของ PushMessageChatUsecase และส่ง dependencies เข้าไป
    ref,
    fireCloudStore,
    baseSharePreference,
    firebaseCloudStorage,
  );
});

class PushMessageChatUsecase extends UseCase<ChatWithPharmacyRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;
  final FirebaseStorageProvider firebaseCloudStorage;

  PushMessageChatUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
    this.firebaseCloudStorage,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ChatWithPharmacyRequest request,
  ) async {
    try {
      //ดึงข้อมูลจาก request หรือใช้ค่าว่างเป็นค่าเริ่มต้น
      final id = request.id ?? '';
      final message = request.message ?? '';
      final chatImg = request.chatImg;
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      //นำ collection 'chat' มาใส่ในตัวแปร
      final collectChat = fireCloudStore.collection('chat');

      //นำ collection 'chat' -> document(id) -> collection 'chat_message' มาใส่ในตัวแปร
      final collect =
          fireCloudStore.collection('chat').doc(id).collection('chat_message');
      //สร้าง id สำหรับ message          
      final messageId = collect.doc().id;
      //สร้างตัวแปรสำหรับเก็บ URL ของรูปภาพ
      String urlChatImg = '';

      //ถ้ามีรูปภาพ (chatImg != null) ให้ทำการ upload รูปภาพไปที่ Firebase Cloud Storage
      if (chatImg != null) {
        urlChatImg = await firebaseCloudStorage.uploadStorage(
          chatImg,
          'chat/$id',
        );
      }

      //ทำการ update document 'chat' ใน Firestore
      await collectChat.doc(id).update({'update_at': DateTime.now()});

      //สร้างข้อมูลที่จะเพิ่มเข้าไปใน collection 'chat' -> document(id) -> collection 'chat_message'
      final Map<String, dynamic> myData = {
        "id": messageId,
        "chatId": id,
        "uid": uid,
        "message": message,
        "chatImg": urlChatImg,
        "create_at": DateTime.now(),
        "update_at": DateTime.now(),
      };

      //เพิ่มข้อมูลลงใน Firestore
      await collect.doc(messageId).set(myData);

      //ส่งค่า true กลับเมื่อทุกอย่างทำเสร็จ
      return true;
    } catch (e) {
      return false;
    }
  }
}
