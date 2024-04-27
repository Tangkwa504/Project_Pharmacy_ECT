import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';

final checkReviewAlreadyUsecaseProvider =
    Provider<CheckReviewAlreadyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return CheckReviewAlreadyUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

// UseCase สำหรับตรวจสอบรีวิว
class CheckReviewAlreadyUsecase extends UseCase<CommentRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  CheckReviewAlreadyUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  // เมธอดสำหรับดำเนินการตรวจสอบรีวิว
  Future<bool> exec(
    CommentRequest request,
  ) async {
    try {
      final orderId = request.orderId; // อ่าน orderId จาก CommentRequest

      final collectReview = await fireCloudStore // ดึงข้อมูลรีวิวจาก Firebase
          .collection('review')
          .where('orderId', isEqualTo: orderId) // กรองตาม orderId
          .get()
          .then(
              (value) => value.docs); // แปลงผลลัพธ์เป็น List<DocumentSnapshot>

      return collectReview.isNotEmpty; // คืนค่า true ถ้าพบรีวิว, false ถ้าไม่พบ
    } catch (e) {
      return false;
    }
  }
}
