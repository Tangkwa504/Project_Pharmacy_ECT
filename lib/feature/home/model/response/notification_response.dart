import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_response.freezed.dart';
part 'notification_response.g.dart';

@immutable
@freezed
abstract class NotificationResponse with _$NotificationResponse {
  @JsonSerializable()
  const factory NotificationResponse({
    String? status,
    String? message,
    String? uid,
    String? id,
    bool? isRead,
    DateTime? createAt,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
}
