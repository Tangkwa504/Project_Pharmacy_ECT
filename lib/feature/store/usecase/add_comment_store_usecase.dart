import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';

final addCommentStoreUsecaseProvider = Provider<AddCommentStoreUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return AddCommentStoreUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class AddCommentStoreUsecase extends UseCase<CommentRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  AddCommentStoreUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    CommentRequest request,
  ) async {
    try {
      //ดึงข้อมูลที่จำเป็นจาก CommentRequest
      final reviewId = request.reviewId;
      final pharmacyId = request.pharmacyId;
      final uid = request.uid;
      final message = request.message;
      
      //สร้าง collection ของ comment ใน Firebase Cloud Firestore
      final collectComment = fireCloudStore
          .collection('review')
          .doc(reviewId)
          .collection('comment');
      final commentId = collectComment.doc().id;

      //กำหนดข้อมูลที่จะเพิ่มลงใน comment
      Map<String, dynamic> myData = {
        "commentId": commentId,
        "reviewId": reviewId,
        "pharmacyId": pharmacyId,
        "uid": uid,
        "message": message,
        "create_at": DateTime.now(),
        "update_at": DateTime.now(),
      };

      //เพิ่ม comment ลงใน Firebase Cloud Firestore
      await collectComment.doc(commentId).set(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
