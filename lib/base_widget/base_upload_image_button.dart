import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/utils/image_picker/image_picker_provider.dart';
import 'package:pharmacy_online/utils/image_picker/model/image_picker_config_request.dart';
import 'package:pharmacy_online/utils/util/base_permission_handler.dart';

class BaseUploadImageButton extends ConsumerStatefulWidget {
  final String? filePath;
  final ImageSource source;
  final Function(XFile? file) onUpload;
  final Widget imgPreview;
  final double? width;
  final double? height;

  // Constructor เพื่อกำหนดค่าพารามิเตอร์
  const BaseUploadImageButton({
    super.key,
    this.filePath,
    this.source = ImageSource.gallery,
    required this.onUpload,
    required this.imgPreview,
    this.width,
    this.height,
  });

  // สร้าง State สำหรับ Widget
  @override
  _BaseUploadImageButtonState createState() => _BaseUploadImageButtonState();
}

class _BaseUploadImageButtonState extends ConsumerState<BaseUploadImageButton> {
  XFile? image;

//Build เพื่อสร้าง UI ของ Widget
  @override
  Widget build(BuildContext context) {
    // GestureDetector เพื่อจัดการกับเหตุการณ์แตะ
    return GestureDetector(
      onTap: () async {
        // ขอสิทธิ์เข้าถึง storage จากระบบ
        final isGrant = await ref
            .read(basePermissionHandlerProvider)
            .requestStoragePermission();

        // ขอสิทธิ์เข้าถึงรูปภาพจากแกลลอรี.
        final isGrant31 = await ref
            .read(basePermissionHandlerProvider)
            .requestPhotosPermission();

        if (isGrant || isGrant31) {
          // ใช้ Image Picker เพื่อเลือกรูปภาพจาก source ที่กำหนด
          final result = await ref.read(imagePickerUtilsProvider).getImage(
                ImagePickerConfigRequest(
                  source: widget.source,
                  maxHeight: 1920,
                  maxWidth: 2560,
                  imageQuality: 30,
                  //isMaximum2MB: true,
                ),
              );

          result.when(
            (success) {
              // หากสำเร็จ, อัปเดต State ด้วยรูปที่เลือก
              setState(() {
                image = success[0];
              });
              // เรียก callback onUpload พร้อมกับรูปที่เลือก
              widget.onUpload(success[0]);
            },
            // หากมีข้อผิดพลาด, แสดง Dialog พร้อมข้อความผิดพลาด
            (error) async {
              await showBaseDialog(
                context: context,
                builder: (ctx) {
                  return BaseDialog(
                    message: error.message,
                  );
                },
              );
            },
          );
        }
      },
      // แสดงรูปที่เลือก, รูป preview หรือ preview ที่กำหนด
      child: image != null
          ? BaseImageView(
              file: File(image!.path),
              width: widget.width ?? 250.w,
              height: widget.height ?? 250.h,
              fit: BoxFit.contain,
            )
          : widget.filePath != null
              ? BaseImageView(
                  url: widget.filePath,
                  width: 250.w,
                  height: 250.h,
                )
              : widget.imgPreview,
    );
  }
}
