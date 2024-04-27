import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';

final getPharmacyInfoUsecaseProvider = Provider<GetPharmacyInfoUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);

  return GetPharmacyInfoUsecase(
    ref,
    fireCloudStore,
  );
});

class GetPharmacyInfoUsecase extends UseCase<void, List<PharmacyInfoResponse>> {
  final FirebaseCloudStore fireCloudStore;

  GetPharmacyInfoUsecase(
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
      //ในกระบวนการดึงข้อมูล, ใช้ `fireCloudStore.collection('user')`
      //เพื่อดึงข้อมูลผู้ใช้ที่มี `status` เป็น "approve" และ `role` เป็น "pharmacy"
      final collectUser = await fireCloudStore
          .collection('user')
          .where(
            'status',
            isEqualTo: "approve",
          )
          .where(
            'role',
            isEqualTo: "pharmacy",
          )
          .get()
          .then((value) => value.docs);

      List<PharmacyInfoResponse> userInfoList = [];
      //วนลูปเพื่อดึงข้อมูลของแต่ละร้านขายยา
      for (final item in collectUser) {
        final _data = item.data() as Map<String, dynamic>;
        //ในแต่ละร้านขายยา, ใช้ `fireCloudStore.collection('pharmacyStore')`
        //เพื่อดึงข้อมูลร้านขายยาที่เชื่อมโยงกับผู้ใช้นี้.
        final collectPharmacyStore = await fireCloudStore
            .collection('pharmacyStore')
            .where(
              'uid',
              isEqualTo: _data['uid'],
            )
            .where(
              'status',
              isEqualTo: 'approve',
            )
            .get()
            .then((value) => value.docs);

        final _pharmacy =
            collectPharmacyStore.first.data() as Map<String, dynamic>;
        //สร้าง `PharmacyInfoResponse` จากข้อมูลที่ได้
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
            longtitude: _pharmacy['longtitude'],
            latitude: _pharmacy['latitude'],
            ratingScore: _pharmacy['ratingScore'] + 0.0,
            countReviewer: _pharmacy['countReviewer'],
          ),
        );
      }

      return userInfoList;
    } catch (e) {
      return const [];
    }
  }
}
