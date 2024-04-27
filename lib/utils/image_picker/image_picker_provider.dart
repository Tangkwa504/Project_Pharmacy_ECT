import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:pharmacy_online/core/error/failure.dart';
import 'package:pharmacy_online/utils/image_picker/enum/image_picker_type_enum.dart';
import 'package:pharmacy_online/utils/image_picker/model/image_picker_config_request.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) {
  return ImagePicker();
});

final imagePickerUtilsProvider = Provider<ImagePickerUtils>(
  (ref) {
    final imagePicker = ref.watch(imagePickerProvider);
    final baseUtils = ref.watch(baseUtilsProvider);
    return ImagePickerUtils(imagePicker, baseUtils);
  },
);

class ImagePickerUtils {
  final ImagePicker imagePicker;
  final BaseUtils baseUtils;
  final _logging = Logger('GET_IMAGE');

  ImagePickerUtils(this.imagePicker, this.baseUtils);

  Future<Result<List<XFile?>, Failure>> getImage(
      ImagePickerConfigRequest request) async {
    try {
      // กำหนดรูปแบบไฟล์ที่อนุญาตให้เลือก
      final _allowFileExtension = ['.jpg', '.png'];
      // ดึงข้อมูลการตั้งค่าจาก request
      final type = request.type;
      final source = request.source;
      final maxWidth = request.maxWidth;
      final maxHeight = request.maxHeight;
      final imageQuality = request.imageQuality;
      final isMaximum2MB = request.isMaximum2MB;
      // กำหนดขนาดไฟล์สูงสุด (2MB)
      const maxFileSizeInBytes = 2 *
          1048576; // 2MB (You'll probably want this outside of this function so you can reuse the value elsewhere)

      // เก็บไฟล์ภาพที่เลือกไว้
      List<XFile?> picker = [];
      // เลือกภาพตามประเภทที่ต้องการ (ภาพเดียวหรือหลายภาพ)
      if (type == ImagePickerType.signle) {
        final result = await imagePicker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );

        // ตรวจสอบไฟล์ที่เลือก
        if (result != null) {
          if (!baseUtils.allowFileExtension(result.path, _allowFileExtension)) {
            return const Success([]); // ส่งกลับรายการว่างหากไม่ตรงตามรูปแบบ
          }

          // ตรวจสอบขนาดไฟล์หากกำหนดขนาดสูงสุดไว้
          if (isMaximum2MB) {
            final imagePath = await result.readAsBytes();
            final fileSize = imagePath.length;
            if (fileSize > maxFileSizeInBytes) {
              return Error(
                Failure(message: 'ขนาดไฟล์เกิน 2 MB'),
              );
            }
          }
        }

        picker.add(result);
      } else {
        picker = await imagePicker.pickMultiImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );

        // ตรวจสอบไฟล์ที่เลือก (แต่ละภาพ)
        if (picker.isNotEmpty) {
          for (final item in picker) {
            if (!baseUtils.allowFileExtension(
              item!.path,
              _allowFileExtension,
            )) {
              return const Success([]); // ส่งกลับรายการว่างหากไม่ตรงตามรูปแบบ
            }

            if (isMaximum2MB) {
              final imagePath = await item.readAsBytes();
              final fileSize = imagePath.length;
              if (fileSize <= maxFileSizeInBytes) {
                return Error(
                  Failure(message: 'ขนาดไฟล์เกิน 2 MB'),
                );
              }
            }
          }
        }
      }
// จัดการกรณีภาพหายบน Android
      if (Platform.isAndroid) {
        // เรียกใช้เมธอด `retrieveLostData()` เพื่อรับรายการไฟล์ภาพที่หายไป
        final response = await imagePicker.retrieveLostData();

        // ตรวจสอบว่ามีไฟล์ภาพที่หายไปหรือไม่
        final List<XFile>? files = response.files;
        if (files != null) {
          return Success(files);
        }
      }

// กำหนดค่าเริ่มต้นสำหรับตัวแปร `res`
      final res = picker;
// ส่งกลับค่า `res` ไปยัง caller
      return Success(res);
    } catch (e) {
      _logging.warning(e);
      return Error(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }
}
