import 'package:freezed_annotation/freezed_annotation.dart';

part 'reviews_response.freezed.dart';
part 'reviews_response.g.dart';

@immutable
@freezed
abstract class ReviewsResponse with _$ReviewsResponse {
  @JsonSerializable()
  const factory ReviewsResponse({
    String? id,
    String? pharmacyId,
    String? uid,
    String? commentId,
    String? fullName,
    String? profileImg,
    double? rating,
    String? message,
    List<CommentResponse>? comments,
    DateTime? createAt,
    DateTime? updateAt,
  }) = _ReviewsResponse;

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewsResponseFromJson(json);
}

@immutable
@freezed
abstract class CommentResponse with _$CommentResponse {
  @JsonSerializable()
  const factory CommentResponse({
    String? commentId,
    String? reviewId,
    String? pharmacyId,
    String? fullName,
    String? profileImg,
    String? uid,
    String? message,
    DateTime? createAt,
    DateTime? updateAt,
  }) = _CommentResponse;

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseFromJson(json);
}
