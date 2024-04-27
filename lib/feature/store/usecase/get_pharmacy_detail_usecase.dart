import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';

final getPharmacyDetailUsecaseProvider =
    Provider<GetPharmacyDetailUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);

  return GetPharmacyDetailUsecase(
    ref,
    fireCloudStore,
  );
});

class GetPharmacyDetailUsecase extends UseCase<String, PharmacyInfoResponse> {
  final FirebaseCloudStore fireCloudStore;

  GetPharmacyDetailUsecase(
    Ref ref,
    this.fireCloudStore,
  ) {
    this.ref = ref;
  }

  @override
  Future<PharmacyInfoResponse> exec(
    String request,
  ) async {
    try {
      //ในกระบวนการดึงข้อมูล, ใช้ `fireCloudStore.collection('user').doc(request).get()`
      //เพื่อดึงข้อมูลผู้ใช้ (ซึ่งเป็นข้อมูลของเจ้าของร้าน)
      final collectUser = await fireCloudStore
          .collection('user')
          .doc(request)
          .get()
          .then((value) => value);

      final _data = collectUser.data() as Map<String, dynamic>;
      //ใช้ข้อมูลผู้ใช้เพื่อดึงข้อมูลของร้านขายยา
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
      //สร้าง `PharmacyInfoResponse` จากข้อมูลที่ได้
      return PharmacyInfoResponse(
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
        qrCode: _pharmacy['qrCodeImg'],
        ratingScore: _pharmacy['ratingScore'] + 0.0,
        countReviewer: _pharmacy['countReviewer'],
      );
    } catch (e) {
      print(e);
      return const PharmacyInfoResponse();
    }
  }
}
