import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_request.freezed.dart';
part 'review_request.g.dart';

@immutable
@freezed
abstract class ReviewRequest with _$ReviewRequest {
  @JsonSerializable()
  const factory ReviewRequest({
    String? reviewId,
    String? storeId,
    double? rating,
    String? pharmacyId,
    String? uid,
    String? message,
    String? orderId,
  }) = _ReviewRequest;

  // สร้าง instance ของ ReviewRequest จาก JSON
  factory ReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewRequestFromJson(json);
}

// ReviewRequest คือคลาสที่ใช้ในการสร้าง object สำหรับรีวิว
// มีคุณสมบัติต่าง ๆ ที่เป็น nullable ตามที่ระบุใน parameter ของ constructor
// เมื่อใช้ Freezed Annotation, จะได้คลาสอื่น ๆ ที่ถูกสร้างขึ้นโดยอัตโนมัติ
// ทำให้มีความสะดวกในการใช้งานและการแปลงข้อมูล

// สามารถแปลง ReviewRequest ไปเป็น JSON ได้โดยใช้ toJson()
// และสามารถสร้าง ReviewRequest จาก JSON ได้โดยใช้ fromJson()