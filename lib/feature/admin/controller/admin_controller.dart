import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/admin/controller/state/admin_state.dart';
import 'package:pharmacy_online/feature/admin/model/request/approve_request.dart';
import 'package:pharmacy_online/feature/admin/usecase/get_pharmacy_detail_usecase.dart';
import 'package:pharmacy_online/feature/admin/usecase/update_approve_pharmacy_usecase.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';

// สร้าง Provider สำหรับ AdminController
final adminControllerProvider =
    StateNotifierProvider<AdminController, AdminState>(
  (ref) {
    // ดูการเปลี่ยนแปลงใน dependencies โดยใช้ ref.watch()
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseUtils = ref.watch(baseUtilsProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final getPharmacyDetailUsecase =
        ref.watch(getPharmacyDetailUsecaseProvider);
    final updateApprovePharmacyUsecase =
        ref.watch(updateApprovePharmacyUsecaseProvider);

    // สร้าง Instance ของ AdminController และให้ dependencies
    return AdminController(
      ref,
      const AdminState(),
      baseFormData,
      baseUtils,
      appNavigator,
      getPharmacyDetailUsecase,
      updateApprovePharmacyUsecase,
    );
  },
);

// กำหนดคลาส AdminController
class AdminController extends StateNotifier<AdminState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseUtils _baseUtils;
  final AppNavigator _appNavigator;
  final GetPharmacyDetailUsecase _getPharmacyDetailUsecase;
  final UpdateApprovePharmacyUsecase _updateApprovePharmacyUsecase;

  // Constructor พร้อม Dependency Injection
  AdminController(
    this._ref,
    AdminState state,
    this._baseFormData,
    this._baseUtils,
    this._appNavigator,
    this._getPharmacyDetailUsecase,
    this._updateApprovePharmacyUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  // เมธอดในการดึงรายละเอียดร้านขายยา
  Future<void> getPharmacyDetail() async {
    final result = await _getPharmacyDetailUsecase.execute(null);

    result.when((success) {
      // อัปเดต State เมื่อได้ผลลัพธ์สำเร็จ
      state = state.copyWith(
        pharmacyInfoList: AsyncValue.data(success),
      );
    }, (error) => null);
  }

  // เมธอดในการอัปเดตรายละเอียดร้านขายยา
  Future<bool> updatePharmacyDetail(
    bool isApprove,
    String uid,
    bool isWarning,
  ) async {
    bool isSuccess = false;
    _loader.onLoad();

    final result = await _updateApprovePharmacyUsecase.execute(
      ApproveRequest(isApprove: isApprove, uid: uid, isWarning: isWarning),
    );

    result.when(
      (success) {
        // อัปเดต State เมื่อได้ผลลัพธ์สำเร็จ
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }
}
