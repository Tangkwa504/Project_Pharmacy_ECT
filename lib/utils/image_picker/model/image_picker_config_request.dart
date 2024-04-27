// อิมพอร์ตไลบรารีที่จำเป็นสำหรับการสร้างคลาส immutable และการเลือกรูปภาพ
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
// อิมพอร์ต enum สำหรับกำหนดประเภทการเลือกรูปภาพ
import 'package:pharmacy_online/utils/image_picker/enum/image_picker_type_enum.dart';

// อ้างอิงไฟล์ generated สำหรับคลาสนี้
part 'image_picker_config_request.freezed.dart';
part 'image_picker_config_request.g.dart';

// ประกาศคลาส ImagePickerConfigRequest เป็น immutable โดยใช้ freezed
@immutable
@freezed
class ImagePickerConfigRequest with _$ImagePickerConfigRequest {
  const factory ImagePickerConfigRequest({
    // ประเภทการเลือกรูปภาพ (single หรือ multiple)
    @Default(ImagePickerType.signle) ImagePickerType type,
    // แหล่งที่มาของรูปภาพ (gallery หรือ camera)
    @Default(ImageSource.gallery) ImageSource source,
    // ความกว้างสูงสุดของรูปภาพที่เลือก (ตัวเลือก)
    double? maxWidth,
    // ความสูงสูงสุดของรูปภาพที่เลือก (ตัวเลือก)
    double? maxHeight,
    // คุณภาพของรูปภาพที่เลือก (ตัวเลือก)
    int? imageQuality,
    // จำกัดขนาดรูปภาพไว้ที่ 2MB หรือไม่ (ตัวเลือก)
    @Default(false) bool isMaximum2MB,
  }) = _ImagePickerConfigRequest;

  // สร้างฟังก์ชันสร้าง Object จาก JSON
  factory ImagePickerConfigRequest.fromJson(Map<String, dynamic> json) =>
      _$ImagePickerConfigRequestFromJson(json);
}
