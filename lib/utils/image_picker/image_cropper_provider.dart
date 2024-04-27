import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

final imageCropperProvider = Provider<ImageCropper>((ref) {
  return ImageCropper();
});

/// Provider logger available only in debug mode
// กำหนด Provider สำหรับ ImageCropperUtils โดยดึง ImageCropper มาใช้
final imageCropperUtilsProvider = Provider<ImageCropperUtils>((ref) {
  final imageCropper = ref.watch(imageCropperProvider);

  return ImageCropperUtils(imageCropper); // สร้าง ImageCropperUtils
});

class ImageCropperUtils {
  final ImageCropper imageCropper;

  ImageCropperUtils(this.imageCropper);

  /// Enable logging only in debug mode
  /// เมธอดสำหรับครอบรูปภาพ
  Future<CroppedFile?> cropImage(XFile? _pickedFile) async {
    final croppedFile = await imageCropper.cropImage(
      // กำหนดค่าต่าง ๆ สำหรับการ crop ภาพ
      sourcePath: _pickedFile!.path, // เส้นทางของรูปภาพต้นฉบับ
      compressFormat: ImageCompressFormat.jpg, // รูปแบบการบีบอัด
      compressQuality: 100, // คุณภาพการบีบอัด (100 = ดีที่สุด)
      uiSettings: [
        // การตั้งค่า UI สำหรับ Android
        AndroidUiSettings(
          toolbarTitle: 'Cropper', // ชื่อ toolbar
          toolbarColor: Colors.deepOrange, // สีของ toolbar
          toolbarWidgetColor: Colors.white, // สีของ widget ใน toolbar
          initAspectRatio: CropAspectRatioPreset.original, // อัตราส่วนเริ่มต้น
          lockAspectRatio: false, // อนุญาตให้ปรับอัตราส่วนได้
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    return croppedFile; // ส่งรูปภาพที่ผ่านการ crop กลับไป
  }
}
