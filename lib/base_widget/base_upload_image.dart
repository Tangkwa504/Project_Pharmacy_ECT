import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/utils/image_picker/image_picker_provider.dart';
import 'package:pharmacy_online/utils/image_picker/model/image_picker_config_request.dart';
import 'package:pharmacy_online/utils/util/base_permission_handler.dart';

// ส่วนนี้เป็น Widget ที่ใช้ในการอัปโหลดรูปภาพ
class BaseUploadImage extends StatefulWidget {
  final String? filePath;
  final String label;
  final ImageSource source;
  final Function(XFile? file) onUpload;

  const BaseUploadImage({
    super.key,
    required this.label,
    this.filePath,
    this.source = ImageSource.gallery,
    required this.onUpload,
  });

  @override
  _BaseUploadImageState createState() => _BaseUploadImageState();
}

class _BaseUploadImageState extends State<BaseUploadImage> {
  String path = '';

  @override
  Widget build(BuildContext context) {
    final label = widget.label;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyle.txtBody2.copyWith(
            color: AppColor.themeGrayLight,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ChooseFileWidget(
                    source: widget.source,
                    onUpload: (file) {
                      setState(() {
                        path = file?.path ?? '';
                      });
                      widget.onUpload(file);
                    },
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      //path.isNotEmpty ? path : 'No file choosen',
                      path.isNotEmpty ? path : 'ยังไม่ได้เลือกไฟล์',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.txtBody2.copyWith(
                        color: AppColor.themeGrayLight,
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 4,
              // ),
              // Text(
              //   '(ไฟล์ .jpg,gif,png ไม่เกิน 2mb)',
              //   style: AppStyle.txtBody2.copyWith(
              //     color: AppColor.themeGrayLight,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

// ส่วนนี้เป็น Widget ที่ใช้ในการเลือกรูปภาพและแสดงปุ่ม "Choose"
class ChooseFileWidget extends ConsumerWidget {
  final Function(XFile? file) onUpload;
  final ImageSource source;

  const ChooseFileWidget({
    super.key,
    required this.onUpload,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        const maxFileSizeInBytes = 2 *
            1048576; // 2MB (You'll probably want this outside of this function so you can reuse the value elsewhere)

        // ขอสิทธิ์ในการเข้าถึง storage
        final isGrant = await ref
            .read(basePermissionHandlerProvider)
            .requestStoragePermission();

        // ขอสิทธิ์ในการเข้าถึงแกลอรี่
        final isGrant31 = await ref
            .read(basePermissionHandlerProvider)
            .requestPhotosPermission();

        if (isGrant || isGrant31) {
          // นำ ref และ ImagePickerConfigRequest ไปใช้เพื่อดึงรูปภาพ
          final result = await ref.read(imagePickerUtilsProvider).getImage(
                ImagePickerConfigRequest(
                  source: source,
                  maxHeight: 1920,
                  maxWidth: 2560,
                  imageQuality: 30,
                  //isMaximum2MB: true,
                ),
              );

          result.when(
            (success) => onUpload(success[0]),
            (error) async {
              // แสดงข้อความผิดพลาดหากไม่สามารถดึงรูปภาพได้
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
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.themePrimaryColor,
        ),
        child: Text(
          'เลือก',
          textAlign: TextAlign.center,
          style: AppStyle.txtBody.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
