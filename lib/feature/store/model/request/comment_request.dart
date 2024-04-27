import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_request.freezed.dart';
part 'comment_request.g.dart';

@immutable
@freezed
abstract class CommentRequest with _$CommentRequest {
  @JsonSerializable()
  const factory CommentRequest({
    String? commentId,
    String? reviewId,
    String? pharmacyId,
    String? uid,
    String? orderId,
    String? message,
    double? rating,
  }) = _CommentRequest;

  factory CommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CommentRequestFromJson(json);
}
