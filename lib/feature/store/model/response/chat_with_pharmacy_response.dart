import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_with_pharmacy_response.freezed.dart';
part 'chat_with_pharmacy_response.g.dart';

@immutable
@freezed
abstract class ChatWithPharmacyResponse with _$ChatWithPharmacyResponse {
  @JsonSerializable()
  const factory ChatWithPharmacyResponse({
    String? id,
    String? uid,
    String? pharmacyId,
    String? chatImg,
    String? status,
    String? message,
    String? fullName,
    String? nameStore,
    String? profileImg,
    String? phone,
    String? phoneStore,
    String? licensePharmacy,
    bool? isOnline,
    DateTime? updateAt,
    DateTime? createAt,
    String? allergy,
  }) = _ChatWithPharmacyResponse;

  factory ChatWithPharmacyResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatWithPharmacyResponseFromJson(json);
}
