import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final firebaseCloudStorageProvider = Provider<FirebaseStorageProvider>((ref) {
  return FirebaseStorageProvider(
    storage: FirebaseStorage.instance,
  );
});

// คลาส FirebaseStorageProvider ทำหน้าที่เป็น Wrapper สำหรับ FirebaseStorage
class FirebaseStorageProvider {
  final FirebaseStorage storage;

  // กำหนดค่า FirebaseStorage
  FirebaseStorageProvider({
    required this.storage,
  });

  // เมธอดสำหรับอัปโหลดไฟล์ไปยัง Firebase Storage
  Future<String> uploadStorage(XFile file, String table) async {
    try {
      // Completer เป็นตัวช่วยในการรอผลลัพธ์จากการอัปโหลด
      final Completer<String> _completer = Completer<String>();

      // ดึงชื่อไฟล์จาก path
      final name = file.path.split('/').last;
      // กำหนด Reference ใน Firebase Storage
      final storageRef = storage.ref('$table/$name');
      // ทำการอัปโหลดไฟล์
      final uploadTask = storageRef.putFile(File(file.path));

      // ติดตามสถานะการอัปโหลด
      uploadTask.snapshotEvents.listen((taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.success:
            // เมื่ออัปโหลดสำเร็จ ทำการดึง URL ของไฟล์ที่อัปโหลด
            _completer.complete(await storageRef.getDownloadURL());
            break;
          case TaskState.paused:
            // กรณีอัปโหลดถูกระงับ
            break;
          case TaskState.running:
            // กรณีอัปโหลดกำลังทำงาน
            break;
          case TaskState.canceled:
            // กรณีอัปโหลดถูกยกเลิก
            _completer.complete('');
            break;
          case TaskState.error:
            // กรณีเกิดข้อผิดพลาดในระหว่างอัปโหลด
            _completer.complete('');
            break;
        }
      });

      // รอรับผลลัพธ์จากการอัปโหลด
      return await _completer.future;
    } catch (e) {
      // กรณีเกิดข้อผิดพลาดในการอัปโหลด
      return '';
    }
  }
}
