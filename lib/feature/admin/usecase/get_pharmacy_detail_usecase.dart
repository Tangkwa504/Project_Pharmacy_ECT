import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';

// Provider สำหรับให้ Consumer สามารถเรียกใช้ GetPharmacyDetailUsecase ได้
final getPharmacyDetailUsecaseProvider =
    Provider<GetPharmacyDetailUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);

  return GetPharmacyDetailUsecase(
    ref,
    fireCloudStore,
  );
});

class GetPharmacyDetailUsecase
    extends UseCase<void, List<PharmacyInfoResponse>> {
  final FirebaseCloudStore fireCloudStore;

  GetPharmacyDetailUsecase(
    Ref ref,
    this.fireCloudStore,
  ) {
    this.ref = ref;
  }

  @override
  Future<List<PharmacyInfoResponse>> exec(
    void request,
  ) async {
    try {
      // ดึงข้อมูลผู้ใช้ที่มีสถานะ "waiting" หรือ "approve" และเป็นบทบาท "pharmacy"
      final collectUser = await fireCloudStore
          .collection('user')
          // .where(
          //   Filter.or(
          //     Filter(
          //       'status',
          //       isEqualTo: "waiting",
          //     ),
          //     Filter(
          //       'status',
          //       isEqualTo: "approve",
          //     ),
          //     Filter(
          //       'status',
          //       isEqualTo: "cancel",
          //     ),
          //     Filter(
          //       'status',
          //       isEqualTo: "approve",
          //     ),
          //  Filter(
          //       'status',
          //       isEqualTo: "waitingEdit",
          //     ),
          //   ),
          // )
          .where(
            'role',
            isEqualTo: "pharmacy",
          )
          .orderBy('update_at')
          .get()
          .then((value) => value.docs);

      List<PharmacyInfoResponse> userInfoList = [];

      for (final item in collectUser.reversed) {
        final _data = item.data() as Map<String, dynamic>;

        final collectPharmacyStore = await fireCloudStore
            .collection('pharmacyStore')
            .where(
              'uid',
              isEqualTo: _data['uid'],
            )
            .get()
            .then((value) => value.docs);

        final _pharmacy =
            collectPharmacyStore.first.data() as Map<String, dynamic>;

        // สร้างออบเจ็กต์ PharmacyInfoResponse จากข้อมูลที่ดึงมา
        userInfoList.add(
          PharmacyInfoResponse(
            uid: _data['uid'],
            email: _data['uid'],
            profileImg: _data['profileImg'],
            fullName: _data['fullName'],
            address: _data['address'],
            licensePharmacy: _pharmacy['licensePharmacy'],
            licensePharmacyImg: _pharmacy['licensePharmacyImg'],
            phone: _data['phone'],
            addressStore: _pharmacy['address'],
            storeImg: _pharmacy['storeImg'],
            nameStore: _pharmacy['nameStore'],
            phoneStore: _pharmacy['phoneStore'],
            timeOpening: _pharmacy['timeOpening'],
            timeClosing: _pharmacy['timeClosing'],
            licenseStore: _pharmacy['licenseStore'],
            licenseStoreImg: _pharmacy['licenseStoreImg'],
            status: _pharmacy['status'],
            ratingScore: _pharmacy['ratingScore'] + 0.0,
            countReviewer: _pharmacy['countReviewer'],
          ),
        );
      }

      return userInfoList;
    } catch (e) {
      // กรณีเกิดข้อผิดพลาดในการดึงข้อมูล
      return const [];
    }
  }
}
