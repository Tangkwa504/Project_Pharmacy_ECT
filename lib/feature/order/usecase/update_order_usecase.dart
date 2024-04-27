import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';

final updateOrderUsecaseProvider = Provider<UpdateOrderUsecase>((ref) {
  // เข้าถึง FirebaseCloudStore และ BaseSharedPreference ผ่าน Riverpod
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return UpdateOrderUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class UpdateOrderUsecase extends UseCase<OrderRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  UpdateOrderUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
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
      final diagnose = request.diagnose;
      final moreDetail = request.moreDetail;
      final howToUse = request.howToUse;
      final status = request.status;

      // อ้างอิงคอลเล็กชัน 'order' ใน Firestore
      final collectOrder = fireCloudStore.collection('order');

      // อัปเดตข้อมูลคำวินิจฉัยและรายละเอียดเพิ่มเติม (ถ้ามี)
      if (diagnose != null) {
        final Map<String, dynamic> myData = {
          "diagnose": diagnose,
          "moreDetail": moreDetail,
          "update_at": DateTime.now(),
        };

        await collectOrder.doc(id).update(myData);
      }

      // อัปเดตข้อมูลวิธีใช้ยาและสถานะตะกร้าสินค้า (ถ้ามี)
      if (cartId != null && howToUse != null) {
        // อัปเดตวิธีใช้ยาสำหรับแต่ละรายการในตะกร้า
        for (final howToUseItem in howToUse) {
          final _medicineData = howToUseItem;

          await fireCloudStore
              .collection('cart')
              .doc(cartId)
              .collection("medicine")
              .doc(_medicineData.entries.first.key)
              .update({'howToUse': _medicineData.entries.first.value});
        }

        // อัปเดตสถานะตะกร้าสินค้าและวันที่อัปเดตล่าสุด
        await fireCloudStore.collection('cart').doc(cartId).update(
          {
            'status': status?.name,
            'update_at': DateTime.now(),
          },
        );
      }

      // อัปเดตสถานะคำสั่งซื้อ (ถ้ามี)
      if (status != null) {
        await collectOrder.doc(id).update({'status': status.name});
      }

      return true; // คืนค่า true ถ้าอัปเดตสำเร็จ
    } catch (e) {
      return false; // คืนค่า false กรณีเกิดข้อผิดพลาด
    }
  }
}
