import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';

final addToCartUsecaseProvider = Provider<AddToCartUsecase>((ref) {
  //โค้ดที่ใช้ในการสร้าง AddToCartUsecase และรับ dependencies ต่าง ๆ
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return AddToCartUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class AddToCartUsecase extends UseCase<CartRequest, bool> {
  //โค้ดที่ประกาศตัวแปรและ dependencies ที่ใช้ใน UseCase
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  AddToCartUsecase(
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
      //โค้ดที่ใช้ในการดึงข้อมูลตะกร้า, สินค้า, และทำการอัปเดตหรือเพิ่มข้อมูลตามเงื่อนไข
      final storeId = request.storeId;
      final _cartId = request.id;
      final uid = request.uid;
      final medicineId = request.medicineId;
      final medicineImg = request.medicineImg;
      final medicineName = request.medicineName;
      final medicinePrice = request.medicinePrice;
      final quantity = request.quantity;
      final nameStore = request.nameStore;
      final medicineSize = request.medicineSize;
      final medicineMaterial = request.medicineMaterial;

      // ดึง pharmacyId ของผู้ใช้จาก shared preferences
      final pharmacyId =
          baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      print(pharmacyId);
      print(uid);

      //ใช้ในการตรวจสอบและอัปเดตหรือเพิ่มข้อมูลตามเงื่อนไข
      final getCart = await fireCloudStore
          .collection('cart')
          .where('uid', isEqualTo: uid)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where('status', isEqualTo: OrderStatus.waitingConfirmOrder.name)
          .get()
          .then((value) => value.docs);

      final collectCart = fireCloudStore.collection('cart');
      final cartId = _cartId;
      Map<String, dynamic>? _dataGetCart;

      List<QueryDocumentSnapshot<Map<String, dynamic>>> getMedicine;
      CollectionReference<Map<String, dynamic>> collectCartMedicine;

      //การใช้ Random ในการสร้างหมายเลขสุ่ม
      final random = Random();
      int randomNumber = random.nextInt(10000);

      //ตรวจสอบว่ามีตะกร้าที่มีสถานะที่กำหนดหรือไม่
      if (getCart.isNotEmpty) {
        //อัปเดตข้อมูลตะกร้าที่มีอยู่
        _dataGetCart = getCart.first.data() as Map<String, dynamic>;

        final Map<String, dynamic> myData = {
          "update_at": DateTime.now(),
        };

        await collectCart.doc(_dataGetCart['id']).update(myData);

        getMedicine = (await fireCloudStore
            .collection('cart')
            .doc(_dataGetCart['id'])
            .collection("medicine")
            .where('medicineId', isEqualTo: medicineId)
            .get()
            .then((value) => value.docs));

        collectCartMedicine = fireCloudStore
            .collection('cart')
            .doc(_dataGetCart['id'])
            .collection("medicine");
      } else {
        //เพิ่มข้อมูลตะกร้าใหม่
        final Map<String, dynamic> myData = {
          "id": cartId,
          "storeId": storeId,
          "pharmacyId": pharmacyId,
          "uid": uid,
          "cartNumber": "C$randomNumber",
          "nameStore": nameStore,
          "status": OrderStatus.waitingConfirmOrder.name,
          "create_at": DateTime.now(),
          "update_at": DateTime.now(),
        };

        await collectCart.doc(cartId).set(myData);

        getMedicine = (await fireCloudStore
            .collection('cart')
            .doc(cartId)
            .collection("medicine")
            .where('medicineId', isEqualTo: medicineId)
            .get()
            .then((value) => value.docs));

        collectCartMedicine = fireCloudStore
            .collection('cart')
            .doc(cartId)
            .collection("medicine");
      }

      final cartMedicineId = collectCartMedicine.doc().id;
      //ตรวจสอบว่ามียาที่มีอยู่ในตะกร้าหรือไม่
      if (getMedicine.isNotEmpty) {
        //อัปเดตข้อมูลยาที่มีอยู่
        final _data = getMedicine.first.data();
        final Map<String, dynamic> myMedicine = {
          "quantity": quantity,
          "medicineImg": medicineImg,
          "medicineName": medicineName,
          "medicinePrice": medicinePrice,
          "medicineId": medicineId,
          "medicineSize": medicineSize,
          "medicineMaterial": medicineMaterial,
        };
        await collectCartMedicine.doc(_data['id']).update(myMedicine);
      } else {
        //เพิ่มข้อมูลยาใหม่
        final Map<String, dynamic> myMedicine = {
          "id": cartMedicineId,
          "quantity": quantity,
          "cartNumber": "C$randomNumber",
          "medicineImg": medicineImg,
          "medicineName": medicineName,
          "medicinePrice": medicinePrice,
          "medicineId": medicineId,
          "medicineSize": medicineSize,
          "medicineMaterial": medicineMaterial,
        };
        await collectCartMedicine.doc(cartMedicineId).set(myMedicine);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
