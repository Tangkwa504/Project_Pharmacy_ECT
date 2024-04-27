import 'package:freezed_annotation/freezed_annotation.dart';

// ส่วนนี้คือการใช้ Freezed และ JsonSerializable
part 'approve_request.freezed.dart';
part 'approve_request.g.dart';

// ประกาศคลาส ApproveRequest และกำหนด Annotation ด้วย @freezed
@immutable
@freezed
abstract class ApproveRequest with _$ApproveRequest {
  // ประกาศคอนสตรัคเตอร์และ Annotation @JsonSerializable
  @JsonSerializable()
  const factory ApproveRequest({
    required bool isApprove,
    required String uid,
    required bool isWarning,
  }) = _ApproveRequest;

  // สร้างเมธอดช่วยในการแปลง JSON เป็น Object และใช้คำสั่ง _$ApproveRequestFromJson
  factory ApproveRequest.fromJson(Map<String, dynamic> json) =>
      _$ApproveRequestFromJson(json);
}
