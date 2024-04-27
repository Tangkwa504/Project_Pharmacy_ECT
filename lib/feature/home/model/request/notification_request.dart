import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_request.freezed.dart';
part 'notification_request.g.dart';

@immutable
@freezed
abstract class NotificationRequest with _$NotificationRequest {
  @JsonSerializable()
  const factory NotificationRequest({
    String? id,
    String? status,
    String? message,
    String? uid,
  }) = _NotificationRequest;

  factory NotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationRequestFromJson(json);
}
