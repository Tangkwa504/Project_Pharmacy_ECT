import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';

final deleteCommentStoreUsecaseProvider =
    Provider<DeleteCommentStoreUsecase>((ref) {
    //ดึงรายการของ dependencies ที่จำเป็นจาก Riverpod
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return DeleteCommentStoreUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class DeleteCommentStoreUsecase extends UseCase<CommentRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  DeleteCommentStoreUsecase(
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
      final reviewId = request.reviewId;
      final commentId = request.commentId;

      //กำหนดตำแหน่งของ document ที่ต้องการลบ
      final collectReview = fireCloudStore
          .collection('review')
          .doc(reviewId)
          .collection('comment')
          .doc(commentId);

      //ลบ document จาก Firestore
      await collectReview.delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
