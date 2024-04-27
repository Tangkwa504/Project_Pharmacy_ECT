import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';

final deleteReviewStoreUsecaseProvider =
    Provider<DeleteReviewStoreUsecase>((ref) {
  //deleteReviewStoreUsecaseProvider คือ Provider ที่ให้บริการ `DeleteReviewStoreUsecase` ซึ่งเป็น `UseCase` ที่ทำหน้าที่ลบรีวิวและความคิดเห็นทั้งหมด
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return DeleteReviewStoreUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class DeleteReviewStoreUsecase extends UseCase<CommentRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  DeleteReviewStoreUsecase(
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
      //ดึง reviewId ที่ต้องการลบจาก request
      final pharmacyId = request.pharmacyId;
      final reviewId = request.reviewId;

      // สร้าง collectReview ซึ่งเป็นคอลเลคชันของ Firebase Cloud Firestore ที่เกี่ยวข้องกับรีวิว
      final collectReview = fireCloudStore.collection('review');

      //ดึงความคิดเห็นทั้งหมดที่เกี่ยวข้องกับรีวิว
      final collectComment = await collectReview
          .doc(reviewId)
          .collection('comment')
          .get()
          .then((value) => value.docs);

      //วนลูปลบทุกความคิดเห็นที่เกี่ยวข้อง
      for (final item in collectComment) {
        final _data = item.data();
        await collectReview
            .doc(reviewId)
            .collection('comment')
            .doc(_data['commentId'])
            .delete();
      }

      final collectPharmacyStore = fireCloudStore.collection('pharmacyStore');

      final getCollectPharmacyStore = await fireCloudStore
          .collection('pharmacyStore')
          .doc(pharmacyId)
          .get()
          .then((value) => value);

      final _dataPharmacy =
          getCollectPharmacyStore.data() as Map<String, dynamic>;

      //คำสั่งลบการรีวิว
      await collectReview.doc(reviewId).delete();

      final getReviewScore = await collectReview
          .where('pharmacyId', isEqualTo: pharmacyId)
          .get()
          .then((value) => value.docs);

      double ratingScore = 0.0;
      double avgRatingScore = 0.0;

      if (getReviewScore.isNotEmpty) {
        for (final item in getReviewScore) {
          final _data = item.data() as Map<String, dynamic>;
          ratingScore += _data['rating'];
        }

        avgRatingScore = ratingScore / getReviewScore.length;
      }
      final countReviewer = _dataPharmacy['countReviewer'] - 1;

      Map<String, dynamic> myPharmacyStore = {
        "ratingScore": countReviewer == 0 ? 0 : avgRatingScore,
        "countReviewer": countReviewer,
        "update_at": DateTime.now(),
      };

      await collectPharmacyStore.doc(pharmacyId).update(myPharmacyStore);

      return true;
    } catch (e) {
      return false;
    }
  }
}
