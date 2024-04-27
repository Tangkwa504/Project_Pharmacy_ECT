import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';

final getCartUsecaseProvider = Provider<GetCartUsecase>((ref) {
  //โค้ดที่ใช้ในการสร้าง GetCartUsecase และรับ dependencies ต่าง ๆ
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return GetCartUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class GetCartUsecase extends UseCase<CartRequest, CartResponse> {
  //โค้ดที่ประกาศตัวแปรและ dependencies ที่ใช้ใน UseCase
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  GetCartUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<CartResponse> exec(
    CartRequest request,
  ) async {
    try {
      //โค้ดที่ใช้ในการดึงข้อมูลของตะกร้าสินค้า
      final uid = request.uid;
      final pharmacyId = request.pharmacyId;
      final status = request.status;
      final cartId = request.id;

      final collectCart = await fireCloudStore
          .collection('cart')
          .where('uid', isEqualTo: uid)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where('status', isEqualTo: status?.name)
          .get()
          .then((value) => value.docs);

      Map<String, dynamic>? _data;

      if (cartId != null) {
        //ดึงข้อมูลตะกร้าสินค้าจาก ID ที่กำหนด
        final collectCartItem = await fireCloudStore
            .collection('cart')
            .doc(cartId)
            .get()
            .then((value) => value);
        _data = collectCartItem.data() as Map<String, dynamic>;
      } else {
        //ดึงข้อมูลตะกร้าสินค้าล่าสุดของผู้ใช้
        _data = collectCart.first.data() as Map<String, dynamic>;
      }
      final List<MedicineResponse> medicineList = [];

      //ดึงข้อมูลสินค้าที่อยู่ในตะกร้าสินค้า
      final collectCartMedicine = await fireCloudStore
          .collection('cart')
          .doc(_data['id'])
          .collection('medicine')
          .get()
          .then((value) => value.docs);

      for (final item in collectCartMedicine) {
        final _data = item.data();

        medicineList.add(
          MedicineResponse(
            id: _data['medicineId'],
            quantity: _data['quantity'],
            medicineImg: _data['medicineImg'],
            name: _data['medicineName'],
            price: _data['medicinePrice'],
            size: _data['medicineSize'],
            material: _data['medicineMaterial'],
            cartMedicineId: _data['id'],
          ),
        );
      }
      //สร้างและคืนค่าข้อมูลตะกร้าสินค้า
      return CartResponse(
        id: _data['id'],
        uid: _data['uid'],
        fullName: _data['fullName'],
        nameStore: _data['nameStore'],
        phone: _data['phone'],
        address: _data['address'],
        district: _data['district'],
        subDistrict: _data['subDistrict'],
        province: _data['province'],
        postNumber: _data['postNumber'],
        cartNumber: _data['cartNumber'],
        pharmacyId: _data['pharmacyId'],
        vatFee: _data['vatFee'],
        deliveryFee: _data['deliveryFee'],
        totalPrice: _data['totalPrice'],
        sumamryPrice: _data['sumamryPrice'],
        medicineList: medicineList,
        status: OrderStatus.values.byName(_data['status']),
        createAt: (_data['create_at'] as Timestamp).toDate(),
        updateAt: (_data['update_at'] as Timestamp).toDate(),
      );
    } catch (e) {
      return const CartResponse();
    }
  }
}
