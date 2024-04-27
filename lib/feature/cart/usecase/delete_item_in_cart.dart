import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';

final deleteItemInCartUsecaseProvider =
    Provider<DeleteItemInCartUsecase>((ref) {
      //โค้ดที่ใช้ในการสร้าง DeleteItemInCartUsecase และรับ dependencies ต่าง ๆ
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return DeleteItemInCartUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class DeleteItemInCartUsecase extends UseCase<CartRequest, bool> {
  //โค้ดที่ประกาศตัวแปรและ dependencies ที่ใช้ใน UseCase
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  DeleteItemInCartUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    CartRequest request,
  ) async {
    try {
      //โค้ดที่ใช้ในการลบสินค้าออกจากตะกร้า
      final cartId = request.id;
      final cartMedicineId = request.cartMedicineId;
      final collectCartMedicine =
          fireCloudStore.collection('cart').doc(cartId).collection("medicine");

      //ลบข้อมูลของสินค้าในตะกร้า
      await collectCartMedicine.doc(cartMedicineId).delete();
      //ตรวจสอบว่าตะกร้าว่างหรือไม่
      final isEmpty =
          (await collectCartMedicine.get().then((value) => value.docs)).isEmpty;
      //ถ้าตะกร้าว่าง ให้ลบตะกร้าทั้งหมดออก
      if (isEmpty) {
        await fireCloudStore.collection('cart').doc(cartId).delete();
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
