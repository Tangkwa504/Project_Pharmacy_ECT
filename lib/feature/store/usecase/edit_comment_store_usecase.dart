import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';

final editCommentStoreUsecaseProvider =
    Provider<EditCommentStoreUsecase>((ref) {
      //editCommentStoreUsecaseProvider คือ Provider ที่ให้บริการ `EditCommentStoreUsecase` ซึ่งเป็น `UseCase` ที่ทำหน้าที่แก้ไขความคิดเห็น
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return EditCommentStoreUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class EditCommentStoreUsecase extends UseCase<CommentRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  EditCommentStoreUsecase(
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
      //ดึง `commentId`, `reviewId`, และ `message` ที่ต้องการแก้ไขจาก `request`
      final commentId = request.commentId;
      final reviewId = request.reviewId;
      final message = request.message;

      //สร้าง `collectReview` ซึ่งเป็นคอลเลคชันของ Firebase Cloud Firestore ที่เกี่ยวข้องกับความคิดเห็นในรีวิว
      final collectReview = fireCloudStore
          .collection('review')
          .doc(reviewId)
          .collection('comment');

      //สร้าง Map ที่ประกอบด้วยข้อมูลที่ต้องการแก้ไข เช่น `message` และ `update_at`
      Map<String, dynamic> myData = {
        "message": message,
        "update_at": DateTime.now(),
      };

      //ทำการอัปเดตความคิดเห็นด้วย `collectReview.doc(commentId).update(myData)`
      await collectReview.doc(commentId).update(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
