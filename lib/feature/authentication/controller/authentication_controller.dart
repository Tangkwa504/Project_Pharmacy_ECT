import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_switch_button.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/authentication/controller/state/authentication_state.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_change_password_enum.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_forgot_password_enum.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_in_enum.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/feature/authentication/model/request/change_password_request.dart';
import 'package:pharmacy_online/feature/authentication/model/request/forgot_password_request.dart';
import 'package:pharmacy_online/feature/authentication/model/request/sign_in_request.dart';
import 'package:pharmacy_online/feature/authentication/model/request/user_info_request.dart';
import 'package:pharmacy_online/feature/authentication/usecase/change_password_usecase.dart';
import 'package:pharmacy_online/feature/authentication/usecase/check_email_has_already_usecase.dart';
import 'package:pharmacy_online/feature/authentication/usecase/create_user_info_usecase.dart';
import 'package:pharmacy_online/feature/authentication/usecase/forgot_password_usecase.dart';
import 'package:pharmacy_online/feature/authentication/usecase/logout_usecase.dart';
import 'package:pharmacy_online/feature/authentication/usecase/sign_in_email_and_password_usecase.dart';

// import '../model/request/change_pass_request.dart';

final authenticationControllerProvider =
    StateNotifierProvider<AuthenticationController, AuthenticationState>(
  (ref) {
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseSharePreference = ref.watch(baseSharePreferenceProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final checkEmailHasAlreadyUsecase =
        ref.watch(checkEmailHasAlreadyUsecaseProvider);
    final createUserInfoUsecase = ref.watch(createUserInfoUsecaseProvider);
    final signInEmailAndPasswordUsecase =
        ref.watch(signInEmailAndPasswordUsecaseProvider);
    final changePasswordUsecase = ref.watch(changePasswordUsecaseProvider);
    final logoutUsecase = ref.watch(logoutUsecaseProvider);
    final forgotPasswordUsecase = ref.watch(forgotPasswordUsecaseProvider);

    return AuthenticationController(
      ref,
      const AuthenticationState(),
      baseFormData,
      baseSharePreference,
      appNavigator,
      checkEmailHasAlreadyUsecase,
      createUserInfoUsecase,
      signInEmailAndPasswordUsecase,
      changePasswordUsecase,
      logoutUsecase,
      forgotPasswordUsecase,
    );
  },
);

class AuthenticationController extends StateNotifier<AuthenticationState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseSharedPreference _baseSharePreference;
  final AppNavigator _appNavigator;
  final CheckEmailHasAlreadyUsecase _checkEmailHasAlreadyUsecase;
  final CreateUserInfoUsecase _createUserInfoUsecase;
  final SignInEmailAndPasswordUseCase _signInEmailAndPasswordUsecase;
  final ChangePasswordUsecase _changePasswordUsecase;
  final LogoutUsecase _logoutUsecase;
  final ForgotPasswordUsecase _forgotPasswordUsecase;

  AuthenticationController(
    this._ref,
    AuthenticationState state,
    this._baseFormData,
    this._baseSharePreference,
    this._appNavigator,
    this._checkEmailHasAlreadyUsecase,
    this._createUserInfoUsecase,
    this._signInEmailAndPasswordUsecase,
    this._changePasswordUsecase,
    this._logoutUsecase,
    this._forgotPasswordUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  void onChanged(BaseFormData baseFormData) {
    final newData = _baseFormData.copyAndMerge(baseFormData);
    state = state.copyWith(baseFormData: newData);
  }

  Future<bool> checkEmailHasAlready() async {
    bool isSuccess = false;
    final email = state.baseFormData?.getValue<String>(FieldSignUp.email);

    if (email != null && email.isNotEmpty) {
      final result = await _checkEmailHasAlreadyUsecase.execute(email);

      result.when((success) => isSuccess = success, (error) => null);
    }

    return isSuccess;
  }

  Future<bool> onSignUp(
    XFile? imgProfile,
    XFile? licensePharmacyImg,
    XFile? licensePharmacyStoreImg,
    XFile? qrCodeImg,
    XFile? store,
    TimeOfDay? openingTime,
    TimeOfDay? closingTime,
  ) async {
    bool isSuccess = false;
    _loader.onLoad();

    final baseFormData = state.baseFormData;
    final email = baseFormData?.getValue<String>(FieldSignUp.email) ?? '';
    final password = baseFormData?.getValue<String>(FieldSignUp.password) ?? '';
    final fullName = baseFormData?.getValue<String>(FieldSignUp.name) ?? '';
    final phone = baseFormData?.getValue<String>(FieldSignUp.phone) ?? '';
    final address = baseFormData?.getValue<String>(FieldSignUp.address);
    final role = baseFormData
        ?.getValue<List<SwitchButtonItem>>(FieldSignUp.role)
        ?.first
        .value;
    final allergy = baseFormData?.getValue<String>(FieldSignUp.allergy) ?? '';

    // Pharmacy & Store
    final nameStore =
        baseFormData?.getValue<String>(FieldSignUp.nameStore) ?? '';
    final addressStore =
        baseFormData?.getValue<String>(FieldSignUp.addressStore) ?? '';
    final phoneStore =
        baseFormData?.getValue<String>(FieldSignUp.phoneStore) ?? '';
    final timeOpening = openingTime == null
        ? ''
        : '${openingTime.hour.toString().padLeft(2, '0')}:${openingTime.minute.toString().padLeft(2, '0')}';
    final timeClosing = closingTime == null
        ? ''
        : '${closingTime.hour.toString().padLeft(2, '0')}:${closingTime.minute.toString().padLeft(2, '0')}';
    final licensePharmacy =
        baseFormData?.getValue<String>(FieldSignUp.licensePharmacy) ?? '';
    final licensePharmacyStore =
        baseFormData?.getValue<String>(FieldSignUp.licensePharmacyStore) ?? '';

    final result = await _createUserInfoUsecase.execute(
      UserInfoRequest(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        address: address ?? addressStore,
        role: role,
        profileImg: imgProfile,
        latitude: state.latitudeStore ?? state.latitudeUser,
        longtitude: state.longtitudeStore ?? state.longtitudeUser,
        nameStore: nameStore,
        phoneStore: phoneStore,
        timeOpening: timeOpening,
        timeClosing: timeClosing,
        licensePharmacy: licensePharmacy,
        licenseStore: licensePharmacyStore,
        licensePharmacyImg: licensePharmacyImg,
        storeImg: store,
        licenseStoreImg: licensePharmacyStoreImg,
        qrCodeImg: qrCodeImg,
        allergy: allergy,
      ),
    );

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  Future<bool> onSignIn() async {
    bool isSuccess = false;
    _loader.onLoad();

    final baseFormData = state.baseFormData;
    final email = baseFormData?.getValue<String>(FieldSignIn.email) ?? '';
    final password = baseFormData?.getValue<String>(FieldSignIn.password) ?? '';

    final result = await _signInEmailAndPasswordUsecase.execute(
      SignInRequest(
        email: email,
        password: password,
      ),
    );

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  void setLatAndLongUser(double latitude, double longtitude) {
    state = state.copyWith(
      latitudeUser: latitude,
      longtitudeUser: longtitude,
    );
  }

  void setLatAndLongPharmacyStore(double latitude, double longtitude) {
    state = state.copyWith(
      latitudeStore: latitude,
      longtitudeStore: longtitude,
    );
  }

  void clearForm() {
    state = state.copyWith(
      baseFormData: null,
      latitudeUser: null,
      latitudeStore: null,
      longtitudeStore: null,
      longtitudeUser: null,
    );
  }

  Future<bool> onLogout() async {
    bool isSuccess = false;
    _loader.onLoad();

    final result = await _logoutUsecase.execute(null);

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  Future<bool> onChangePassword() async {
    bool isSuccess = false;
    _loader.onLoad();

    final baseFormData = state.baseFormData;
    final currentPassword =
        baseFormData?.getValue<String>(FieldChangePassword.currentPassword) ??
            '';
    final newPassword =
        baseFormData?.getValue<String>(FieldChangePassword.newPassword) ?? '';

    final result = await _changePasswordUsecase.execute(
      ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  Future<bool> onForgotPassword() async {
    bool isSuccess = false;
    _loader.onLoad();

    final baseFormData = state.baseFormData;
    final email =
        baseFormData?.getValue<String>(FieldForgotPassword.email) ?? '';

    final result = await _forgotPasswordUsecase.execute(
      ForgotPasswordRequest(
        email: email,
      ),
    );

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }
}
