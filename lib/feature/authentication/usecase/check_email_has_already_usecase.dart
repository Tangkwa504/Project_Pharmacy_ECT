import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';

final checkEmailHasAlreadyUsecaseProvider =
    Provider<CheckEmailHasAlreadyUsecase>((ref) {
    //รับ dependency จาก Provider ต่างๆ
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  return CheckEmailHasAlreadyUsecase(
    ref,
    fireCloudStore,
  );
});

class CheckEmailHasAlreadyUsecase extends UseCase<String, bool> {
  final FirebaseCloudStore fireCloudStore;

  CheckEmailHasAlreadyUsecase(
    Ref ref,
    this.fireCloudStore,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    String request,
  ) async {
    try {
      //ค้นหาข้อมูลใน Firestore collection 'user' ที่มี 'email' เท่ากับค่าที่รับเข้ามา
      final collect = await fireCloudStore
          .collection('user')
          .where(
            'email',
            isEqualTo: request,
          )
          .get()
          .then((value) => value.docs);
      //ถ้ามีข้อมูล (collect ไม่ว่างเปล่า) แสดงว่าอีเมลนี้มีอยู่ในระบบแล้ว
      return collect.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
