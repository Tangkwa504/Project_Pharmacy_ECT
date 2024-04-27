import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';

final editCartUsecaseProvider = Provider<EditCartUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return EditCartUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class EditCartUsecase extends UseCase<CartRequest, bool> {
  //โค้ดที่ประกาศตัวแปรและ dependencies ที่ใช้ใน UseCase
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  EditCartUsecase(
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
      //โค้ดที่ใช้ในการแก้ไขข้อมูลสินค้าในตะกร้า
      final cartId = request.id;
      final cartMedicineId = request.cartMedicineId;

      final medicineId = request.medicineId;
      final medicineImg = request.medicineImg;
      final medicineName = request.medicineName;
      final medicinePrice = request.medicinePrice;
      final quantity = request.quantity;
      final medicineSize = request.medicineSize;
      final medicineMaterial = request.medicineMaterial;

      final collectCart = fireCloudStore.collection('cart');

      //อัปเดตเวลาที่แก้ไขล่าสุดของตะกร้า
      await collectCart.doc(cartId).update({'update_at': DateTime.now()});

      final collectCartMedicine =
          fireCloudStore.collection('cart').doc(cartId).collection("medicine");

      final _cartMedicineId = collectCartMedicine.doc().id;

      final Map<String, dynamic> myMedicine = {
        "id": cartMedicineId ?? _cartMedicineId,
        "quantity": quantity,
        "medicineImg": medicineImg,
        "medicineName": medicineName,
        "medicinePrice": medicinePrice,
        "medicineId": medicineId,
        "medicineSize": medicineSize,
        "medicineMaterial": medicineMaterial,
      };

      //ตรวจสอบว่าเป็นการแก้ไขข้อมูลหรือเพิ่มข้อมูลใหม่
      if (cartMedicineId != null) {
        await collectCartMedicine.doc(cartMedicineId).update(myMedicine);
      } else {
        await collectCartMedicine.doc(cartMedicineId).set(myMedicine);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
