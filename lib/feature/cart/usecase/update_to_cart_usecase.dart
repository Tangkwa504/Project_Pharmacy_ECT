import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';

final updateToCartUsecaseProvider = Provider<UpdateToCartUsecase>((ref) {
  //โค้ดที่ใช้ในการสร้าง UpdateToCartUsecase และรับ dependencies ต่าง ๆ
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return UpdateToCartUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class UpdateToCartUsecase extends UseCase<CartRequest, bool> {
  //โค้ดที่ประกาศตัวแปรและ dependencies ที่ใช้ใน UseCase
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  UpdateToCartUsecase(
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
      //โค้ดที่ใช้ในการดึงข้อมูลจาก CartRequest
      final cartId = request.id;
      final vatFee = request.vatFee;
      final status = request.status;
      final deliveryFee = request.deliveryFee;
      final totalPrice = request.totalPrice;
      final summaryPrice = request.summaryPrice;
      final fullName = request.fullName;
      final phone = request.phone;
      final address = request.address;
      final district = request.district;
      final subDistrict = request.subDistrict;
      final province = request.province;
      final postNumber = request.postNumber;
      final collectCart = fireCloudStore.collection('cart');

      
      //อัปเดตข้อมูลใน Firebase Cloud Firestore
      final Map<String, dynamic> myData = {
        "vatFee": vatFee,
        "deliveryFee": deliveryFee,
        "totalPrice": totalPrice,
        "summaryPrice": summaryPrice,
        "status": status?.name,
        "fullName": fullName,
        "phone": phone,
        "address": address,
        "district": district,
        "subDistrict": subDistrict,
        "province": province,
        "postNumber": postNumber,
        "update_at": DateTime.now(),
      };
      //อัปเดตข้อมูล
      await collectCart.doc(cartId).update(myData);

      return true;  //รีเทินค่าเพื่อบอกว่าการอัปเดตสำเร็จ
    } catch (e) {
      return false; //รีเทินค่าเพื่อบอกว่าการอัปเดตไม่สำเร็จ
    }
  }
}
