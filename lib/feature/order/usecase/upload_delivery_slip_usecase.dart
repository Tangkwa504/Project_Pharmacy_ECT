import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';

final updatDeliverySlipUsecaseProvider =
    Provider<UpdatDeliverySlipUsecase>((ref) {
  // เข้าถึง FirebaseCloudStore, BaseSharedPreference และ FirebaseCloudStorage ผ่าน Riverpod
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);

  return UpdatDeliverySlipUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
    firebaseCloudStorage,
  );
});

class UpdatDeliverySlipUsecase extends UseCase<OrderRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;
  final FirebaseStorageProvider firebaseCloudStorage;

  UpdatDeliverySlipUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
    this.firebaseCloudStorage,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    OrderRequest request,
  ) async {
    try {
      // อ่านข้อมูลคำขอจาก OrderRequest
      final id = request.id;
      final cartId = request.cartId;
      final deliverySlip = request.deliverySlip;

      // อ้างอิงคอลเล็กชัน 'order' ใน Firebase Cloud Firestore
      final collectOrder = fireCloudStore.collection('order');

      String urlDeliverySlip = '';

      // อัปโหลดหลักฐานการส่งสินค้าไปยัง Firebase Storage (ถ้ามี)
      if (deliverySlip != null) {
        urlDeliverySlip = await firebaseCloudStorage.uploadStorage(
          deliverySlip,
          'order/$id',
        );
      }

      // สร้างข้อมูลที่จะอัปเดตคำสั่งซื้อ
      final Map<String, dynamic> myData = {
        "deliverySlip": urlDeliverySlip,
        "status": OrderStatus.waitingDelivery.name,
        "update_at": DateTime.now(),
      };

      // อัปเดตข้อมูลคำสั่งซื้อใน Firebase Cloud Firestore
      await collectOrder.doc(id).update(myData);

      // อัปเดตสถานะของตะกร้าสินค้า (ถ้ามี)
      if (cartId != null) {
        await fireCloudStore.collection('cart').doc(cartId).update(
          {
            "status": OrderStatus.waitingDelivery.name,
            'update_at': DateTime.now(),
          },
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
