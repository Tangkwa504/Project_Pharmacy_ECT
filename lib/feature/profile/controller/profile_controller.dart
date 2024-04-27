import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/authentication/model/request/user_info_request.dart';
import 'package:pharmacy_online/feature/authentication/usecase/update_pharmacy_store_usecase.dart';
import 'package:pharmacy_online/feature/authentication/usecase/update_user_info_usecase.dart';
import 'package:pharmacy_online/feature/profile/controller/state/profile_state.dart';
import 'package:pharmacy_online/feature/profile/enum/field_user_info_enum.dart';
import 'package:pharmacy_online/feature/profile/usecase/change_qr_code_usecase.dart';
import 'package:pharmacy_online/feature/profile/usecase/get_pharmacy_store_usecase.dart';
import 'package:pharmacy_online/feature/profile/usecase/get_user_info_usecase.dart';

// import '../model/request/change_pass_request.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>(
  (ref) {
    // ดึงข้อมูล
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseSharePreference = ref.watch(baseSharePreferenceProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final getUserInfoUsecase = ref.watch(getUserInfoUsecaseProvider);
    final getPharmacyUsecase = ref.watch(getPharmacyUsecaseProvider);
    final updateUserInfoUsecase = ref.watch(updateUserInfoUsecaseProvider);
    final updatePharmacyStoreUsecase =
        ref.watch(updatePharmacyStoreUsecaseProvider);
    final changeQRCodeUsecase = ref.watch(changeQRCodeUsecaseProvider);

    // สร้าง ProfileController พร้อมกับการส่ง Dependency ที่ต้องใช้
    return ProfileController(
      ref,
      const ProfileState(),
      baseFormData,
      baseSharePreference,
      appNavigator,
      getUserInfoUsecase,
      getPharmacyUsecase,
      updateUserInfoUsecase,
      updatePharmacyStoreUsecase,
      changeQRCodeUsecase,
    );
  },
);

// คลาส ProfileController ที่ใช้เป็น StateNotifier สำหรับการจัดการ State ของหน้าจอ Profile
class ProfileController extends StateNotifier<ProfileState> {
  // ตัวแปรที่ใช้เก็บ Ref และ Dependency ต่าง ๆ ที่ใช้ใน Controller
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseSharedPreference _baseSharePreference;
  final AppNavigator _appNavigator;
  final GetUserInfoUseCase _getUserInfoUsecase;
  final GetPharmacyUseCase _getPharmacyUsecase;
  final UpdateUserInfoUsecase _updateUserInfoUsecase;
  final UpdatePharmacyStoreUsecase _updatePharmacyStoreUsecase;
  final ChangeQRCodeUsecase _changeQRCodeUsecase;

  // คอนสตรักเตอร์สำหรับกำหนดค่าเริ่มต้นของตัวแปร
  ProfileController(
    this._ref,
    ProfileState state,
    this._baseFormData,
    this._baseSharePreference,
    this._appNavigator,
    this._getUserInfoUsecase,
    this._getPharmacyUsecase,
    this._updateUserInfoUsecase,
    this._updatePharmacyStoreUsecase,
    this._changeQRCodeUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  // เมธอดที่ใช้ในการอัพเดทข้อมูลใน State
  void onChanged(BaseFormData baseFormData) {
    final newData = _baseFormData.copyAndMerge(baseFormData);
    state = state.copyWith(baseFormData: newData);
  }

  void clearForm() {
    state = state.copyWith(
      baseFormData: null,
      latitudeStore: null,
      latitudeUser: null,
      longtitudeStore: null,
      longtitudeUser: null,
    );
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

  // เมธอดที่ใช้ในการดึงข้อมูลผู้ใช้
  Future<void> onGetUserInfo() async {
    _loader.onLoad();
    final result = await _getUserInfoUsecase.execute(null);

    result.when(
      // กรณีดึงข้อมูลสำเร็จ
      (success) {
        state = state.copyWith(
          userInfo: success,
          isPharmacy: success.role == AuthenticationType.pharmacy.name,
        );

        _loader.onDismissLoad();
      },
      // กรณีเกิดข้อผิดพลาด
      (error) => _loader.onDismissLoad(),
    );
  }

  // เมธอดที่ใช้ในการดึงข้อมูลร้านขายยา
  Future<void> onGetPharmacyStore() async {
    _loader.onLoad();

    final result = await _getPharmacyUsecase.execute(null);

    result.when(
      // กรณีดึงข้อมูลสำเร็จ
      (success) {
        state = state.copyWith(
          pharmacyStore: success,
        );
        _loader.onDismissLoad();
      },
      // กรณีเกิดข้อผิดพลาด
      (error) => _loader.onDismissLoad(),
    );
  }

  // เมธอดที่ใช้ในการอัพเดทข้อมูลผู้ใช้
  Future<bool> onUpdateUserInfo(
    XFile? imgProfile, //รูปโปรไฟล์
    XFile? imgLicensePharmacy, //รูปใบอนุญาต
  ) async {
    _loader.onLoad();

    bool isSuccess = false;

    final baseFormData = state.baseFormData;
    final userInfo = state.userInfo;
    final fullName = baseFormData?.getValue<String>(FieldUserInfo.name) ??
        userInfo?.fullName;
    final phone =
        baseFormData?.getValue<String>(FieldUserInfo.phone) ?? userInfo?.phone;
    final address = baseFormData?.getValue<String>(FieldUserInfo.address) ??
        userInfo?.address;
    // final licensePharmacy =
    //     baseFormData?.getValue<String>(FieldUserInfo.licensePharmacy) ??
    //         userInfo?.licensePharmacy;
    final licensePharmacy =
        baseFormData?.getValue<String>(FieldUserInfo.licensePharmacy) ??
            state.pharmacyStore?.licensePharmacy;
    final allergy = baseFormData?.getValue<String>(FieldUserInfo.allergy) ??
        userInfo?.allergy;

    final result = await _updateUserInfoUsecase.execute(
      UserInfoRequest(
        fullName: fullName,
        phone: phone,
        address: address,
        role: state.userInfo?.role ?? 'user',
        latitude: state.latitudeStore ?? state.latitudeUser,
        longtitude: state.longtitudeStore ?? state.longtitudeUser,
        licensePharmacy: licensePharmacy,
        profileImg: imgProfile,
        currentProfileImg: state.userInfo?.profileImg ?? '',
        licensePharmacyImg: imgLicensePharmacy,
        currentLicensePharmacyImg:
            state.pharmacyStore?.licensePharmacyImg ?? '',
        allergy: allergy,
      ),
    );

    result.when((success) => isSuccess = success, (error) => null);

    return isSuccess;
  }

  // เมธอดที่ใช้ในการอัพเดทข้อมูลร้านขายยา
  Future<bool> onUpdatePharmacyStore(
    XFile? licensePharmacyStoreImg, //รูปใบอนุญาต
    XFile? store, // รูปร้าน
    TimeOfDay openingTime,
    TimeOfDay closingTime,
  ) async {
    _loader.onLoad();

    bool isSuccess = false;

    final baseFormData = state.baseFormData;
    final pharmacyStore = state.pharmacyStore;

    // Pharmacy & Store
    final nameStore = baseFormData?.getValue<String>(FieldUserInfo.nameStore) ??
        pharmacyStore?.nameStore;
    final addressStore =
        baseFormData?.getValue<String>(FieldUserInfo.addressStore) ??
            pharmacyStore?.address;
    final phoneStore =
        baseFormData?.getValue<String>(FieldUserInfo.phoneStore) ??
            pharmacyStore?.phoneStore;
    final timeOpening =
        '${openingTime.hour.toString().padLeft(2, '0')}:${openingTime.minute.toString().padLeft(2, '0')}';
    final timeClosing =
        '${closingTime.hour.toString().padLeft(2, '0')}:${closingTime.minute.toString().padLeft(2, '0')}';
    final licensePharmacy =
        baseFormData?.getValue<String>(FieldUserInfo.licensePharmacy) ??
            pharmacyStore?.licensePharmacy;
    final licensePharmacyStore =
        baseFormData?.getValue<String>(FieldUserInfo.licensePharmacyStore) ??
            pharmacyStore?.licenseStore;

    final result = await _updatePharmacyStoreUsecase.execute(
      UserInfoRequest(
        address: addressStore,
        latitude: state.latitudeStore ?? state.latitudeUser,
        longtitude: state.longtitudeStore ?? state.longtitudeUser,
        nameStore: nameStore,
        phoneStore: phoneStore,
        timeOpening: timeOpening,
        timeClosing: timeClosing,
        licensePharmacy: licensePharmacy,
        licenseStore: licensePharmacyStore,
        storeImg: store,
        licenseStoreImg: licensePharmacyStoreImg,
        currentLicensePharmacyImg:
            state.pharmacyStore?.licensePharmacyImg ?? '',
        currentLicenseStoreImg: state.pharmacyStore?.licenseStoreImg ?? '',
        currentQrCodeImg: state.pharmacyStore?.qrCodeImg ?? '',
        currentStoreImg: state.pharmacyStore?.storeImg ?? '',
      ),
    );

    result.when((success) => isSuccess = success, (error) => null);

    return isSuccess;
  }

  // เมธอดที่ใช้ในการเปลี่ยนรูปภาพ QR Code
  Future<bool> onChangeQRCode(XFile? qrcodeImg) async {
    _loader.onLoad();
    bool isSuccess = false;

    if (qrcodeImg == null) {
      _loader.onDismissLoad();
      return isSuccess;
    }

    final result = await _changeQRCodeUsecase.execute(qrcodeImg);

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
