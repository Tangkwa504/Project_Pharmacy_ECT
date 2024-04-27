import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';

final deleteOrderUsecaseProvider = Provider<DeleteOrderUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return DeleteOrderUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

// UseCase สำหรับลบคำสั่งซื้อ
class DeleteOrderUsecase extends UseCase<OrderRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  DeleteOrderUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  // เมธอดสำหรับดำเนินการลบคำสั่งซื้อ
  Future<bool> exec(
    OrderRequest request,
  ) async {
    try {
      final id = request.id; // อ่าน id ของคำสั่งซื้อจาก OrderRequest
      final cartId =
          request.cartId; // อ่าน cartId ของคำสั่งซื้อจาก OrderRequest

      final collectOrder = fireCloudStore
          .collection('order'); // อ้างอิง collection 'order' ใน Firebase

      await collectOrder
          .doc(id)
          .delete(); // ลบเอกสารคำสั่งซื้อใน collection 'order'

      final collectMedicine = fireCloudStore
          .collection('cart'); // อ้างอิง collection 'cart' ใน Firebase

      await collectMedicine
          .doc(cartId)
          .delete(); // ลบเอกสารสินค้าในตะกร้าใน collection 'cart'

      return true;
    } catch (e) {
      return false;
    }
  }
}
