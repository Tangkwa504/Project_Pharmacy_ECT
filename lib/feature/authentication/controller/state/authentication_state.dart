import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/feature/authentication/model/response/pharmacy_store_response.dart';
import 'package:pharmacy_online/feature/authentication/model/response/user_info_response.dart';

part 'authentication_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    BaseFormData? baseFormData,
    String? errMsg,
    UserInfoResponse? userInfo,
    PharmacyStoreResponse? pharmacyStore,
    double? latitudeUser,
    double? longtitudeUser,
    double? latitudeStore,
    double? longtitudeStore,
  }) = _AuthenticationState;
}
