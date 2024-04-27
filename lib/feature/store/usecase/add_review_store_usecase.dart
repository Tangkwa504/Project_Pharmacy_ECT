import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/model/request/review_request.dart';

final addReviewStoreUsecaseProvider = Provider<AddReviewStoreUsecase>((ref) {
  //ดึง dependencies ที่จำเป็น
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return AddReviewStoreUsecase(
    //สร้างและคืน instance ของ UseCase
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class AddReviewStoreUsecase extends UseCase<ReviewRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  AddReviewStoreUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ReviewRequest request,
  ) async {
    try {
      //ดึงข้อมูลที่จำเป็นจาก ReviewRequest
      final orderId = request.orderId;
      final pharmacyId = request.pharmacyId;
      final uid = request.uid;
      final message = request.message;
      final rating = request.rating;

      //สร้าง collection ของ review ใน Firebase Cloud Firestore
      final collectReview = fireCloudStore.collection('review');
      final reviewId = collectReview.doc().id;
      //กำหนดข้อมูลที่จะเพิ่มลงใน review
      Map<String, dynamic> myData = {
        "id": reviewId,
        "orderId": orderId,
        "rating": rating,
        "pharmacyId": pharmacyId,
        "uid": uid,
        "message": message,
        "create_at": DateTime.now(),
        "update_at": DateTime.now(),
      };

      //เพิ่ม review ลงใน Firebase Cloud Firestore
      await collectReview.doc(reviewId).set(myData);

      final collectPharmacyStore = fireCloudStore.collection('pharmacyStore');

      final getCollectPharmacyStore = await fireCloudStore
          .collection('pharmacyStore')
          .doc(pharmacyId)
          .get()
          .then((value) => value);

      final _dataPharmacy =
          getCollectPharmacyStore.data() as Map<String, dynamic>;

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
      final countReviewer = _dataPharmacy['countReviewer'] + 1;

      Map<String, dynamic> myPharmacyStore = {
        "ratingScore": avgRatingScore,
        "countReviewer": countReviewer,
        "update_at": DateTime.now(),
      };

      await collectPharmacyStore.doc(pharmacyId).update(myPharmacyStore);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
