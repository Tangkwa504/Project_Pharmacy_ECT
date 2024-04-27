import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_response.freezed.dart';
part 'user_info_response.g.dart';

@immutable
@freezed
abstract class UserInfoResponse with _$UserInfoResponse {
  @JsonSerializable()
  const factory UserInfoResponse({
    String? uid,
    String? email,
    String? password,
    String? role,
    String? profileImg,
    String? fullName,
    String? address,
    String? licensePharmacy,
    String? licensePharmacyImg,
    String? phone,
    double? latitude,
    double? longtitude,
    String? status,
    DateTime? update_at,
    DateTime? create_at,
    String? allergy,
  }) = _UserInfoResponse;

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UserInfoResponseFromJson(json);
}
