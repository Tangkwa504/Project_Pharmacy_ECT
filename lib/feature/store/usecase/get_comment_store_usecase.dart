import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';
import 'package:pharmacy_online/feature/store/model/response/reviews_response.dart';

final getCommentStoreUsecaseProvider = Provider<GetCommentStoreUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return GetCommentStoreUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class GetCommentStoreUsecase
    extends UseCase<CommentRequest, List<CommentResponse>> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  GetCommentStoreUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<List<CommentResponse>> exec(
    CommentRequest request,
  ) async {
    try {
      //ในกระบวนการดึงข้อมูล, ใช้ `fireCloudStore.collection('review').doc(reviewId).collection('comment').get()` 
      //เพื่อดึงข้อมูลความคิดเห็นทั้งหมดที่เกี่ยวข้องกับรีวิวนั้น ๆ
      //และจัดเรียงตามวันที่สร้าง (create_at).
      final reviewId = request.reviewId;

      final collectReview = await fireCloudStore
          .collection('review')
          .doc(reviewId)
          .collection('comment')
          .orderBy('create_at')
          .get()
          .then((value) => value.docs);

      //วนลูปเพื่อดึงข้อมูลความคิดเห็น.
      List<CommentResponse> commentList = [];

      for (final item in collectReview.reversed) {
        final _data = item.data();


        //ดึงข้อมูลผู้ใช้งานจาก Firebase Cloud Firestore
        final collectUser = await fireCloudStore
            .collection('user')
            .doc(_data['uid'])
            .get()
            .then((value) => value);

        final _user = collectUser.data() as Map<String, dynamic>;

        //สร้าง `CommentResponse` จากข้อมูลที่ได้
        commentList.add(
          CommentResponse(
            commentId: _data['commentId'],
            reviewId: _data['reviewId'],
            pharmacyId: _data['pharmacyId'],
            uid: _data['uid'],
            fullName: _user['fullName'],
            profileImg: _user['profileImg'],
            message: _data['message'],
            createAt: (_data['create_at'] as Timestamp).toDate(),
          ),
        );
      }

      return commentList;
    } catch (e) {
      //ในกรณีที่เกิดข้อผิดพลาดในการดึงข้อมูล, ส่งรายการความคิดเห็นที่ว่างกลับ
      return [];
    }
  }
}
