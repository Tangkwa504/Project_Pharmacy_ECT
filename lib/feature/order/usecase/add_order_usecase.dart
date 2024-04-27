import 'dart:math'; // นำเข้าไลบรารี math เพื่อใช้ฟังก์ชัน Random

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';

final addOrderUsecaseProvider = Provider<AddOrderUsecase>((ref) {
  final fireCloudStore =
      ref.watch(firebaseCloudStoreProvider); // อ่าน FirebaseCloudStore
  final baseSharedPreference =
      ref.watch(baseSharePreferenceProvider); // อ่าน BaseSharedPreference

  return AddOrderUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

// UseCase สำหรับเพิ่มคำสั่งซื้อ
class AddOrderUsecase extends UseCase<OrderRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  AddOrderUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  // เมธอดสำหรับดำเนินการเพิ่มคำสั่งซื้อ
  Future<bool> exec(
    OrderRequest request,
  ) async {
    try {
      final storeId = request.storeId; // อ่าน storeId จาก OrderRequest
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);
      final pharmacyId = request.pharmacyId;
      final cartId = request.cartId;

      final collectOrder = fireCloudStore
          .collection('order'); // อ้างอิง collection 'order' ใน Firebase
      final orderId =
          collectOrder.doc().id; // สร้างเอกสารใหม่ใน collection และรับ orderId

      final random = Random(); // สร้างออบเจ็กต์ Random เพื่อสุ่มตัวเลข
      int randomNumber = random.nextInt(10000); // สุ่มตัวเลข 4 หลัก

      // สร้าง Map สำหรับข้อมูลออเดอร์
      final Map<String, dynamic> myData = {
        "id": orderId,
        "storeId": storeId,
        "orderNumber":
            "ORDER$randomNumber", // สร้าง orderNumber โดยนำหน้าด้วย "ORDER"
        "pharmacyId": pharmacyId,
        "uid": uid,
        "cartId": cartId,
        "status": OrderStatus
            .confirmOrder.name, // กำหนดสถานะออเดอร์เป็น "confirmOrder"
        "create_at": DateTime.now(), // บันทึกวันที่และเวลาสร้างออเดอร์
        "update_at": DateTime.now(), // บันทึกวันที่และเวลาอัปเดตล่าสุด
      };

      await collectOrder
          .doc(orderId)
          .set(myData); // บันทึกข้อมูลออเดอร์ลง Firebase

      return true; // คืนค่า true แสดงว่าบันทึกสำเร็จ
    } catch (e) {
      return false; // คืนค่า false แสดงว่าบันทึกไม่สำเร็จ
    }
  }
}
