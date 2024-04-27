import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';

final getAllMyCartUsecaseProvider = Provider<GetAllMyCartUsecase>((ref) {
  //โค้ดที่ใช้ในการสร้าง GetAllMyCartUsecase และรับ dependencies ต่าง ๆ
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return GetAllMyCartUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class GetAllMyCartUsecase extends UseCase<CartRequest, List<CartResponse>> {
  //โค้ดที่ประกาศตัวแปรและ dependencies ที่ใช้ใน UseCase
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  GetAllMyCartUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<List<CartResponse>> exec(
    CartRequest request,
  ) async {
    try {
      //โค้ดที่ใช้ในการดึงข้อมูลตะกร้าสินค้า
      final isPharamcy = request.isPharmacy;
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);
      final status = request.status;

      List<QueryDocumentSnapshot<Object?>>? collectCart;

      if (isPharamcy) {
        //ดึงข้อมูลตะกร้าสินค้าจากร้านขายยา
        collectCart = await fireCloudStore
            .collection('cart')
            .where('pharmacyId', isEqualTo: uid)
            .where('status', isEqualTo: status?.name)
            .orderBy('create_at')
            .get()
            .then((value) => value.docs);
      } else {
        //ดึงข้อมูลตะกร้าสินค้าของผู้ใช้
        collectCart = await fireCloudStore
            .collection('cart')
            .where('uid', isEqualTo: uid)
            .where('status', isEqualTo: status?.name)
            .orderBy('create_at')
            .get()
            .then((value) => value.docs);
      }

      if (collectCart != null && collectCart.isNotEmpty) {
        final List<CartResponse> cartList = [];

        for (final item in collectCart.reversed) {
          final _data = item.data() as Map<String, dynamic>;

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
                material: _data['medicineMaterial'],
                size: _data['medicineSize'],
                cartMedicineId: _data['id'],
              ),
            );
          }

          //ดึงข้อมูลผู้ใช้ที่ทำการสั่งซื้อ
          final collectUser = await fireCloudStore
              .collection('user')
              .doc(_data['uid'])
              .get()
              .then((value) => value);
          final _user = collectUser.data() as Map<String, dynamic>;

          //เพิ่มข้อมูลตะกร้าสินค้าใน List
          cartList.add(
            CartResponse(
              id: _data['id'],
              uid: _data['uid'],
              nameStore: _data['nameStore'],
              cartNumber: _data['cartNumber'],
              pharmacyId: _data['pharmacyId'],
              fullName: _user['fullName'],
              vatFee: _data['vatFee'],
              deliveryFee: _data['deliveryFee'],
              totalPrice: _data['totalPrice'],
              sumamryPrice: _data['sumamryPrice'],
              medicineList: medicineList,
              status: OrderStatus.values.byName(_data['status']),
              createAt: (_data['create_at'] as Timestamp).toDate(),
              updateAt: (_data['update_at'] as Timestamp).toDate(),
            ),
          );
        }

        return cartList;
      }
      return const [];
    } catch (e) {
      return const [];
    }
  }
}
