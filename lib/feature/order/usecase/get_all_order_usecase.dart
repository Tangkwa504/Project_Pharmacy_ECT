import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';
import 'package:pharmacy_online/feature/order/model/response/order_response.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';

final getAllOrderUsecaseProvider = Provider<GetAllOrderUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return GetAllOrderUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class GetAllOrderUsecase extends UseCase<OrderRequest, List<OrderResponse>> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  GetAllOrderUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<List<OrderResponse>> exec(
    OrderRequest request,
  ) async {
    try {
      final isPharmacy = request.isPharmacy; // อ่านค่า isPharmacy จาก request
      final userId = baseSharedPreference.getString(
          BaseSharePreferenceKey.userId); // อ่าน user ID จาก SharedPreferences

      List<QueryDocumentSnapshot<Object?>>?
          getAllOrder; // ตัวแปรเก็บข้อมูลคำสั่งซื้อทั้งหมด

      // ค้นหาคำสั่งซื้อตามเงื่อนไขว่าผู้ใช้เป็นร้านขายยาหรือผู้ใช้ทั่วไป
      if (isPharmacy) {
        getAllOrder = await fireCloudStore
            .collection('order')
            .where('pharmacyId', isEqualTo: userId)
            .orderBy('create_at')
            .get()
            .then((value) => value.docs);
      } else {
        getAllOrder = await fireCloudStore
            .collection('order')
            .where('uid', isEqualTo: userId)
            .orderBy('create_at')
            .get()
            .then((value) => value.docs);
      }

      // ตรวจสอบหากไม่พบคำสั่งซื้อ คืนค่า list ว่าง
      if (getAllOrder == null) {
        return [];
      }

      List<OrderResponse> orderList =
          []; // ตัวแปรเก็บข้อมูลคำสั่งซื้อในรูปแบบ OrderResponse

      // วนลูปสร้าง OrderResponse จากข้อมูลคำสั่งซื้อแต่ละอัน
      for (final item in getAllOrder.reversed) {
        final _data = item.data() as Map<String, dynamic>;

        // ดึงข้อมูลตะกร้าสินค้าที่เกี่ยวข้อง
        final getCart = await fireCloudStore
            .collection('cart')
            .where('id', isEqualTo: _data['cartId'])
            .get()
            .then((value) => value.docs);

        final cartData = getCart.first.data() as Map<String, dynamic>;

        // ดึงข้อมูลยาในตะกร้าสินค้า
        final List<MedicineResponse> medicineList = [];

        final collectCartMedicine = await fireCloudStore
            .collection('cart')
            .doc(cartData['id'])
            .collection('medicine')
            .get()
            .then((value) => value.docs);

        for (final itemMedicine in collectCartMedicine) {
          final _dataMedicine = itemMedicine.data();

          // ข้อมูลของยาแต่ละตัว
          medicineList.add(
            MedicineResponse(
              id: _dataMedicine['medicineId'],
              quantity: _dataMedicine['quantity'],
              medicineImg: _dataMedicine['medicineImg'],
              name: _dataMedicine['medicineName'],
              price: _dataMedicine['medicinePrice'],
              size: _dataMedicine['medicineSize'],
              material: _dataMedicine['medicineMaterial'],
              cartMedicineId: _dataMedicine['id'],
            ),
          );
        }

        // สร้าง CartResponse จากข้อมูลตะกร้าสินค้า
        final cartResponse = CartResponse(
          id: cartData['id'],
          pharmacyId: cartData['pharmacyId'],
          cartNumber: cartData['cartNumber'],
          uid: cartData['uid'],
          nameStore: cartData['nameStore'],
          fullName: cartData['fullName'],
          phone: cartData['phone'],
          address: cartData['address'],
          district: cartData['district'],
          subDistrict: cartData['subDistrict'],
          province: cartData['province'],
          postNumber: cartData['postNumber'],
          vatFee: cartData['vatFee'],
          deliveryFee: cartData['deliveryFee'],
          totalPrice: cartData['totalPrice'],
          sumamryPrice: cartData['sumamryPrice'],
          medicineList: medicineList,
          status: OrderStatus.values.byName(cartData['status']),
          createAt: (cartData['create_at'] as Timestamp).toDate(),
          updateAt: (cartData['update_at'] as Timestamp).toDate(),
        );

        // สร้าง OrderResponse และเพิ่มเข้า list
        orderList.add(
          OrderResponse(
            id: _data['id'],
            pharmacyId: _data['pharmacyId'],
            uid: _data['uid'],
            cartId: _data['cartId'],
            myCart: cartResponse,
            status: OrderStatus.values.byName(_data['status']),
            diagnose: _data['diagnose'],
            orderNumber: _data['orderNumber'],
            moreDetail: _data['moreDetail'],
            bankTransferSlip: _data['bankTransferSlip'],
            deliverySlip: _data['deliverySlip'],
            bankTransferDate: _data['bankTransferDate'],
            bankTotalPriceSlip: _data['bankTotalPriceSlip'],
            createAt: (_data['create_at'] as Timestamp).toDate(),
            updateAt: (_data['update_at'] as Timestamp).toDate(),
          ),
        );
      }

      return orderList;
    } catch (e) {
      return [];
    }
  }
}
