//import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_switch_button.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/order/model/request/review_request.dart';
import 'package:pharmacy_online/feature/store/controller/state/store_state.dart';
import 'package:pharmacy_online/feature/store/enum/field_medicine_enum.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';
import 'package:pharmacy_online/feature/store/model/request/medicine_request.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/usecase/add_central_medicine_to_my_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/add_comment_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/add_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/add_review_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/approve_chat_with_pharmacy_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/check_request_chat_already_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/check_request_chat_waiting_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/delete_comment_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/delete_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/delete_review_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/edit_comment_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/edit_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/edit_review_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_central_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_comment_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_pharmacy_detail_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_pharmacy_info_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_request_chat_with_pharmacy_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_review_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/request_chat_with_pharmacy_usecase.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';
import 'package:pharmacy_online/utils/util/date_format.dart';

//riverpod ดึงข้อมูลจาก usecase มาใช้
final storeControllerProvider =
    StateNotifierProvider<StoreController, StoreState>(
  (ref) {
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseUtils = ref.watch(baseUtilsProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final addMedicineWarehouseUsecase =
        ref.watch(addMedicineWarehouseUsecaseProvider);
    final deleteMedicineWarehouseUsecase =
        ref.watch(deleteMedicineWarehouseUsecaseProvider);
    final editMedicineWarehouseUsecase =
        ref.watch(editMedicineWarehouseUsecaseProvider);
    final getCentralMedicineWarehouseUsecase =
        ref.watch(getCentralMedicineWarehouseUsecaseProvider);
    final getMedicineWarehouseUsecase =
        ref.watch(getMedicineWarehouseUsecaseProvider);
    final addCentralMedicineToMyWarehouseUsecase =
        ref.watch(addCentralMedicineToMyWarehouseUsecaseProvider);
    final getPharmacyInfoUsecase = ref.watch(getPharmacyInfoUsecaseProvider);
    final requestChatWithPharmacyUsecase =
        ref.watch(requestChatWithPharmacyUsecaseProvider);
    final getGetRequestChatWithPharmacyUsecase =
        ref.watch(getGetRequestChatWithPharmacyUsecaseProvider);
    final approveChatWithPharmacyUsecase =
        ref.watch(approveChatWithPharmacyUsecaseProvider);
    final getPharmacyDetailUsecase =
        ref.watch(getPharmacyDetailUsecaseProvider);
    final getReviewStoreUsecase = ref.watch(getReviewStoreUsecaseProvider);
    final getCommentStoreUsecase = ref.watch(getCommentStoreUsecaseProvider);
    final addReviewStoreUsecase = ref.watch(addReviewStoreUsecaseProvider);
    final addCommentStoreUsecase = ref.watch(addCommentStoreUsecaseProvider);
    final editReviewStoreUsecase = ref.watch(editReviewStoreUsecaseProvider);
    final editCommentStoreUsecase = ref.watch(editCommentStoreUsecaseProvider);
    final deleteReviewStoreUsecase =
        ref.watch(deleteReviewStoreUsecaseProvider);
    final deleteCommentStoreUsecase =
        ref.watch(deleteCommentStoreUsecaseProvider);
    final checkRequestChatAlreadyUsecase =
        ref.watch(checkRequestChatAlreadyUsecaseProvider);
    final checkRequestChatWaitingUsecase =
        ref.watch(checkRequestChatWaitingUsecaseProvider);
    return StoreController(
      ref,
      const StoreState(),
      baseFormData,
      baseUtils,
      appNavigator,
      addMedicineWarehouseUsecase,
      deleteMedicineWarehouseUsecase,
      editMedicineWarehouseUsecase,
      getCentralMedicineWarehouseUsecase,
      getMedicineWarehouseUsecase,
      addCentralMedicineToMyWarehouseUsecase,
      getPharmacyInfoUsecase,
      requestChatWithPharmacyUsecase,
      getGetRequestChatWithPharmacyUsecase,
      approveChatWithPharmacyUsecase,
      getPharmacyDetailUsecase,
      getReviewStoreUsecase,
      getCommentStoreUsecase,
      addReviewStoreUsecase,
      addCommentStoreUsecase,
      editReviewStoreUsecase,
      editCommentStoreUsecase,
      deleteReviewStoreUsecase,
      deleteCommentStoreUsecase,
      checkRequestChatAlreadyUsecase,
      checkRequestChatWaitingUsecase,
    );
  },
);

class StoreController extends StateNotifier<StoreState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseUtils _baseUtils;
  final AppNavigator _appNavigator;
  final AddMedicineWarehouseUsecase _addMedicineWarehouseUsecase;
  final DeleteMedicineWarehouseUsecase _deleteMedicineWarehouseUsecase;
  final EditMedicineWarehouseUsecase _editMedicineWarehouseUsecase;
  final GetCentralMedicineWarehouseUsecase _getCentralMedicineWarehouseUsecase;
  final GetMedicineWarehouseUsecase _getMedicineWarehouseUsecase;
  final AddCentralMedicineToMyWarehouseUsecase
      _addCentralMedicineToMyWarehouseUsecase;
  final GetPharmacyInfoUsecase _getPharmacyInfoUsecase;
  final RequestChatWithPharmacyUsecase _requestChatWithPharmacyUsecase;
  final GetRequestChatWithPharmacyUsecase _getGetRequestChatWithPharmacyUsecase;
  final ApproveChatWithPharmacyUsecase _approveChatWithPharmacyUsecase;
  final GetPharmacyDetailUsecase _getPharmacyDetailUsecase;
  final GetReviewStoreUsecase _getReviewStoreUsecase;
  final GetCommentStoreUsecase _getCommentStoreUsecase;
  final AddReviewStoreUsecase _addReviewStoreUsecase;
  final AddCommentStoreUsecase _addCommentStoreUsecase;
  final EditReviewStoreUsecase _editReviewStoreUsecase;
  final EditCommentStoreUsecase _editCommentStoreUsecase;
  final DeleteReviewStoreUsecase _deleteReviewStoreUsecase;
  final DeleteCommentStoreUsecase _deleteCommentStoreUsecase;
  final CheckRequestChatAlreadyUsecase _checkRequestChatAlreadyUsecase;
  final CheckRequestChatWaitingUsecase _checkRequestChatWaitingUsecase;

  StoreController(
    this._ref,
    StoreState state,
    this._baseFormData,
    this._baseUtils,
    this._appNavigator,
    this._addMedicineWarehouseUsecase,
    this._deleteMedicineWarehouseUsecase,
    this._editMedicineWarehouseUsecase,
    this._getCentralMedicineWarehouseUsecase,
    this._getMedicineWarehouseUsecase,
    this._addCentralMedicineToMyWarehouseUsecase,
    this._getPharmacyInfoUsecase,
    this._requestChatWithPharmacyUsecase,
    this._getGetRequestChatWithPharmacyUsecase,
    this._approveChatWithPharmacyUsecase,
    this._getPharmacyDetailUsecase,
    this._getReviewStoreUsecase,
    this._getCommentStoreUsecase,
    this._addReviewStoreUsecase,
    this._addCommentStoreUsecase,
    this._editReviewStoreUsecase,
    this._editCommentStoreUsecase,
    this._deleteReviewStoreUsecase,
    this._deleteCommentStoreUsecase,
    this._checkRequestChatAlreadyUsecase,
    this._checkRequestChatWaitingUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

// เมธอดสำหรับอัปเดตสถานะเมื่อข้อมูลในฟอร์มเปลี่ยนแปลง
  void onChanged(BaseFormData baseFormData) {
    // สร้างสำเนาของข้อมูลฟอร์มปัจจุบันและผสานกับข้อมูลที่เข้ามาใหม่
    final newData = _baseFormData.copyAndMerge(baseFormData);
    // อัปเดตสถานะโดยแทนที่ข้อมูลฟอร์มด้วยข้อมูลที่ผสานแล้ว
    state = state.copyWith(baseFormData: newData);
  }

// เมธอดสำหรับล้างข้อมูลในฟอร์ม
  void clearForm() {
    state = state.copyWith(baseFormData: null);
  }

// เมธอดสำหรับเพิ่มยาในคลังยา
  Future<bool> addMedicineWarehouse(XFile medicineImg) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    // ดึงข้อมูลยาจากสถานะปัจจุบัน
    final baseFormData = state.baseFormData;

    final name = baseFormData?.getValue<String>(FieldMedicine.name);

    final price = baseFormData?.getValue<String>(FieldMedicine.price) ?? '0.0';
    final material =
        baseFormData?.getValue<String>(FieldMedicine.material) ?? '';
    final size = baseFormData?.getValue<String>(FieldMedicine.size) ?? '';

    // ตรวจสอบว่าผู้ใช้เป็น admin หรือไม่
    final isAdmin = _ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    // เรียกใช้ usecase เพื่อเพิ่มยาในคลังยา
    final result = await _addMedicineWarehouseUsecase.execute(
      MedicineRequest(
        name: name,
        price: double.parse(
            isAdmin ? '0.0' : price), // หากเป็น admin ให้ราคาเป็น 0
        medicineImg: medicineImg,
        material: material,
        size: size,
      ),
    );

    // จัดการผลลัพธ์ของการเรียกใช้ usecase
    result.when(
      (success) {
        isSuccess = true;
        _loader.onDismissLoad(); // ปิด loading indicator
      },
      (error) =>
          _loader.onDismissLoad(), // ปิด loading indicator เมื่อเกิดข้อผิดพลาด
    );

    return isSuccess;
  }

// เมธอดสำหรับแก้ไขข้อมูลยาในคลังยา
  Future<bool> editMedicineWarehouse(
    String id,
    XFile? medicineImg,
    String? currentMedicineImg,
  ) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    // ดึงข้อมูลยาจากสถานะปัจจุบัน
    final baseFormData = state.baseFormData;
    final name = baseFormData?.getValue<String>(FieldMedicine.name);
    final price = baseFormData?.getValue<String>(FieldMedicine.price) ?? '0.0';
    final material = baseFormData?.getValue<String>(FieldMedicine.material);
    final size = baseFormData?.getValue<String>(FieldMedicine.size);

    // เรียกใช้ usecase เพื่อแก้ไขข้อมูลยา
    final result = await _editMedicineWarehouseUsecase.execute(
      MedicineRequest(
        id: id,
        name: name,
        price: double.parse(price),
        currentMedicineImg: currentMedicineImg,
        medicineImg: medicineImg,
        material: material,
        size: size,
      ),
    );

    // จัดการผลลัพธ์ของการเรียกใช้ usecase
    result.when(
      (success) {
        isSuccess = true;
        _loader.onDismissLoad(); // ปิด loading indicator
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับลบยาออกจากคลังยา
  Future<bool> deleteMedicineWarehouse(String? id) async {
    bool isSuccess = false;

    // เรียกใช้ usecase เพื่อลบยา
    final result = await _deleteMedicineWarehouseUsecase.execute(
      MedicineRequest(
        id: id,
      ),
    );

    // จัดการผลลัพธ์ของการเรียกใช้ usecase
    result.when((success) => isSuccess = true, (error) => null);

    return isSuccess;
  }

// เมธอดสำหรับดึงข้อมูลยาจากคลังกลาง
  Future<void> onGetCentralMedicineWarehouse() async {
    state = state.copyWith(
      centralMedicineList: const AsyncValue.loading(), // แสดงสถานะ loading
    );
    final result = await _getCentralMedicineWarehouseUsecase.execute(null);
    result.when(
      (success) => state = state.copyWith(
        centralMedicineList:
            AsyncValue.data(success), // แสดงข้อมูลยาที่ดึงมาได้
      ),
      (error) => state = state.copyWith(
        centralMedicineList:
            const AsyncValue.data([]), // แสดงข้อมูลว่างเมื่อเกิดข้อผิดพลาด
      ),
    );
  }

// เมธอดสำหรับดึงข้อมูลยาจากคลังยาของผู้ใช้
  Future<void> onGetMedicineWarehouse() async {
    state = state.copyWith(
      medicineList: const AsyncValue.loading(), // แสดงสถานะ loading
    );
    final result = await _getMedicineWarehouseUsecase.execute(null);

    result.when(
      (success) => state = state.copyWith(
        medicineList: AsyncValue.data(success), // แสดงข้อมูลยาที่ดึงมาได้
      ),
      (error) => state = state.copyWith(
        medicineList:
            const AsyncValue.data([]), // แสดงข้อมูลว่างเมื่อเกิดข้อผิดพลาด
      ),
    );
  }

// เมธอดสำหรับเพิ่มยาจากคลังกลางไปยังคลังยาของผู้ใช้
  Future<bool> onAddCentralMedicineToMyWarehouse(
      MedicineResponse medicineItem) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    // เรียกใช้ usecase เพื่อเพิ่มยา
    final result = await _addCentralMedicineToMyWarehouseUsecase.execute(
      MedicineRequest(
        id: medicineItem.id,
        name: medicineItem.name,
        price: medicineItem.price,
        currentMedicineImg: medicineItem.medicineImg,
        material: medicineItem.material,
        size: medicineItem.size,
      ),
    );

    // จัดการผลลัพธ์ของการเรียกใช้ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad(); // ปิด loading indicator
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับดึงข้อมูลร้านขายยาและตำแหน่งปัจจุบันของผู้ใช้
  Future<void> getPharmacyInfo() async {
    // เรียกใช้ usecase เพื่อดึงข้อมูลร้านขายยา
    final result = await _getPharmacyInfoUsecase.execute(null);

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) => state = state.copyWith(
        pharmacyInfoList: AsyncValue.data(success), // เก็บข้อมูลร้านยา
      ),
      (error) => null,
    );

    // ดึงตำแหน่งปัจจุบันของผู้ใช้
    final myLocation = await _ref.read(baseUtilsProvider).getLocation();
    myLocation.when(
      (success) {
        state = state.copyWith(
          myLatitude: success.latitude,
          myLongtitude: success.longitude,
        ); // เก็บพิกัด
      },
      (error) => null,
    );
  }

// เมธอดสำหรับส่งคำขอแชทกับร้านขายยา
  Future<bool> onRequestChatWithPharmacy(String pharmacyId) async {
    bool isSuccess = false;
    _loader.onLoad(); // แสดง loading indicator

    // เรียกใช้ usecase เพื่อส่งคำขอแชท
    final result = await _requestChatWithPharmacyUsecase.execute(
      ChatWithPharmacyRequest(
        pharmacyId: pharmacyId,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(), // ปิด loading indicator
    );

    return isSuccess;
  }

// เมธอดสำหรับดึงคำขอแชทที่ผู้ใช้ได้รับ
  Future<void> onGetGetRequestChatWithPharmacy() async {
    final result = await _getGetRequestChatWithPharmacyUsecase.execute(null);

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        state = state.copyWith(
          chatWithPharmacyList: AsyncValue.data(success), // เก็บข้อมูลคำขอแชท
        );
      },
      (error) => state = state.copyWith(
        chatWithPharmacyList:
            const AsyncValue.data([]), // แสดงข้อมูลว่างเมื่อเกิดข้อผิดพลาด
      ),
    );
  }

// เมธอดสำหรับอนุมัติหรือปฏิเสธคำขอแชท
  Future<bool> onApproveChatWithPharmacy(
    bool isApprove,
    String id,
  ) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    final result = await _approveChatWithPharmacyUsecase.execute(
      ChatWithPharmacyRequest(
        isApprove: isApprove,
        id: id,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        _loader.onDismissLoad();
        isSuccess = success;
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับดึงข้อมูลรายละเอียดร้านขายยา
  Future<void> onGetPharmacyDetail(
    String pharmacyId, {
    bool isLoading = false,
  }) async {
    if (isLoading) {
      _loader.onLoad();
    }

    final result = await _getPharmacyDetailUsecase.execute(pharmacyId);

    // จัดการผลลัพธ์ของ usecase
    result.when((success) {
      if (isLoading) {
        _loader.onDismissLoad();
      }
      state = state.copyWith(pharmacyDetail: AsyncValue.data(success));
    }, (error) {
      if (isLoading) {
        _loader.onDismissLoad();
      }
      state = state.copyWith(
        pharmacyDetail: const AsyncValue.data(null),
      );
    });
  }

// เมธอดสำหรับดึงข้อมูลรีวิวของร้านขายยา
  Future<void> onGetReview(
    String pharmacyId,
  ) async {
    final result = await _getReviewStoreUsecase.execute(
      ReviewRequest(pharmacyId: pharmacyId),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        state = state.copyWith(reviewList: AsyncValue.data(success));
      },
      (error) => state = state.copyWith(
        reviewList: const AsyncValue.data(null),
      ),
    );
  }

// เมธอดสำหรับดึงข้อมูลคอมเมนต์ของรีวิว
  Future<void> onGetComment(
    String reviewId,
  ) async {
    final result = await _getCommentStoreUsecase.execute(
      CommentRequest(reviewId: reviewId),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        state = state.copyWith(commentList: AsyncValue.data(success));
      },
      (error) => state = state.copyWith(
        commentList: const AsyncValue.data(null),
      ),
    );
  }

// เมธอดสำหรับเพิ่มรีวิวร้านขายยา
  Future<bool> onAddReview(
    String orderId,
    String pharmacyId,
    String uid,
    String message,
    double rating,
  ) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    if (message.isEmpty) {
      // ข้ามการเรียกใช้ usecase หากข้อความรีวิวว่าง
      return true;
    }

    final result = await _addReviewStoreUsecase.execute(
      ReviewRequest(
        orderId: orderId,
        pharmacyId: pharmacyId,
        uid: uid,
        message: message,
        rating: rating,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับเพิ่มคอมเมนต์ใต้รีวิว
  Future<bool> onAddComment(
    String reviewId,
    String pharmacyId,
    String uid,
    String message,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    final result = await _addCommentStoreUsecase.execute(
      CommentRequest(
        reviewId: reviewId,
        pharmacyId: pharmacyId,
        uid: uid,
        message: message,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับแก้ไขรีวิวร้านขายยา
  Future<bool> onEditReview(
    String pharmacyId,
    String reviewId,
    double rating,
    String message,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    // เรียกใช้ usecase เพื่อแก้ไขรีวิว
    final result = await _editReviewStoreUsecase.execute(
      ReviewRequest(
        pharmacyId: pharmacyId,
        reviewId: reviewId,
        rating: rating,
        message: message,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับแก้ไขคอมเมนต์ใต้รีวิว
  Future<bool> onEditComment(
    String reviewId,
    String commentId,
    String message,
  ) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    // เรียกใช้ usecase เพื่อแก้ไขคอมเมนต์
    final result = await _editCommentStoreUsecase.execute(
      CommentRequest(
        reviewId: reviewId,
        commentId: commentId,
        message: message,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad(); // ปิด loading indicator
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับลบรีวิวร้านขายยา
  Future<bool> onDeleteReview(
    String pharmacyId,
    String reviewId,
  ) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    final result = await _deleteReviewStoreUsecase.execute(
      CommentRequest(
        pharmacyId: pharmacyId,
        reviewId: reviewId,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับลบคอมเมนต์ใต้รีวิว
  Future<bool> onDeleteComment(
    String reviewId,
    String commentId,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    // เรียกใช้ usecase เพื่อลบคอมเมนต์
    final result = await _deleteCommentStoreUsecase.execute(
      CommentRequest(
        reviewId: reviewId,
        commentId: commentId,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับตรวจสอบว่ามีคำขอแชทกับร้านขายยานี้อยู่แล้วหรือไม่
  Future<void> onCheckRequestChatAlready(String pharmacyId) async {
    final result = await _checkRequestChatAlreadyUsecase.execute(
      ChatWithPharmacyRequest(
        pharmacyId: pharmacyId,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) => state = state.copyWith(
        checkRequestChatAlready: success,
      ),
      (error) => null,
    );
  }

// เมธอดสำหรับตรวจสอบว่ามีคำขอแชทกับร้านขายยานี้ที่รอการอนุมัติหรือไม่
  Future<void> onCheckRequestChatWaiting(String pharmacyId) async {
    // เรียกใช้ usecase เพื่อตรวจสอบ
    final result = await _checkRequestChatWaitingUsecase.execute(
      ChatWithPharmacyRequest(
        pharmacyId: pharmacyId,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      // หากสำเร็จ เก็บข้อมูลผลลัพธ์ลงใน state
      (success) => state = state.copyWith(
        checkRequestChatWaiting: success,
      ),
      (error) => null,
    );
  }

  void onSearchMedicine(String medicine) async {
    final centralMedicineList = state.centralMedicineList.value;

    if (medicine.isEmpty) {
      state = state.copyWith(searchCentralMedicineList: null);
      return;
    }

    if (medicine == 'all') {
      state = state.copyWith(searchCentralMedicineList: centralMedicineList);
      return;
    }

    if (centralMedicineList == null) return;

    final searchcentralMedicineList = centralMedicineList.where(
      (e) {
        final _name = e.name!.toLowerCase();
        final _size = e.size?.toLowerCase();

        final name = _name.contains(
          medicine,
        );
        final size = _size?.contains(
          medicine,
        );

        if (_size != null) {
          return name || size!;
        }

        return name;
      },
    ).toList();

    state =
        state.copyWith(searchCentralMedicineList: searchcentralMedicineList);
  }

  void onSearchMyMedicine(String medicine) async {
    final medicineList = state.medicineList.value;

    if (medicine.isEmpty) {
      state = state.copyWith(searchMedicineList: null);
      return;
    }

    if (medicine == 'all') {
      state = state.copyWith(searchMedicineList: medicineList);
      return;
    }

    if (medicineList == null) return;

    final searchMedicineList = medicineList.where(
      (e) {
        final _name = e.name!.toLowerCase();
        final _size = e.size?.toLowerCase();
        final _price = '${e.price}';

        final name = _name.contains(
          medicine,
        );

        final size = _size?.contains(
          medicine,
        );

        final price = _price.contains(
          medicine,
        );

        if (_size != null) {
          return name || size! || price;
        }

        return name || price;
      },
    ).toList();

    state = state.copyWith(searchMedicineList: searchMedicineList);
  }

  // ค้นหาร้านเภสัช
  void onSearchPharmacyStore({
    // เช็ดว่าเป็นค้นหาทั้งหมดหรือไม่
    bool isAll = false,
    // ค้นหาด้วยชื่อ
    String? name,
  }) async {
    state = state.copyWith(searchError: '', searchPharmacyInfoList: null);

    // ทำการดึงข้อมูล pharmacy ทั้งหมดในระบบมาก่อน
    final pharmacyInfoList = state.pharmacyInfoList.value;

    // ถ้าเป็นการค้นหาทั้งหมด และทำไปเก็บใน searchPharmacyInforList และไปที่หน้า search result
    if (isAll) {
      state = state.copyWith(
        searchPharmacyInfoList: pharmacyInfoList,
      );
      return;
    }

    // ดึงข้อมูลค้นหาของ field อื่น
    final distance = state.searchDistance;
    final reviewScore = state.searchReviewScore;
    final countReviewer = state.searchCountReviewer;
    final openPharmacy = state.searchTimeOpen;

    // ถ้า pharmachInfoList เป็น null ให้หยุดทำงาน
    if (pharmacyInfoList == null) return;

    List<PharmacyInfoResponse> _pharmacyInfoList = [];

    //ฟิลเตอร์เวลาเปิดทำการ

    if (openPharmacy) {
      _pharmacyInfoList = pharmacyInfoList.where((val) {
        final currentTime = DateTime.now();
        var timeClosing = _ref
            .read(baseDateFormatterProvider)
            .convertTimeStringToDateTime(
              val.timeClosing ?? '${currentTime.hour}:${currentTime.minute}',
            );
        var timeOpening = _ref
            .read(baseDateFormatterProvider)
            .convertTimeStringToDateTime(
              val.timeOpening ?? '${currentTime.hour}:${currentTime.minute}',
            );

        //ถ้า timeClosing มาก่อน timeOpening ปรับ timeOpening ลบ 1 วัน แสดงวันเปิดวันปัจจุบัน user หลังเที่ยงคืนใช้ได้
        // if (timeClosing.isBefore(timeOpening)) {
        //   timeOpening = timeOpening.subtract(Duration(days: 1));
        // }
        // ถ้า timeClosing อยู่ก่อน timeOpening timeClosing จะถูกเพิ่ม 1 วัน timeClosing ใหม่ จะแสดงเวลาปิดของวันถัดไป
        //  if (timeClosing.isBefore(timeOpening)) {
        //   timeClosing = timeClosing.add(Duration(days: 1));
        // }

        // ปรับเวลาเปิดร้านให้ถูกต้องถ้า timeClosing อยู่ก่อน timeOpening
        if (timeClosing.isBefore(timeOpening)) {
          // ปรับเวลาปิดร้านถ้า currentTime มากกว่า 12.00 น.
          if (currentTime.hour >= 12) {
            timeClosing = timeClosing.add(Duration(days: 1));
          } else {
            // ปรับเวลาเปิดร้านถ้า currentTime น้อยกว่า 12.00 น.
            timeOpening = timeOpening.subtract(Duration(days: 1));
          }
        }
        return currentTime.isAfter(timeOpening) &&
            currentTime.isBefore(timeClosing);
      }).toList();

      if (_pharmacyInfoList.isEmpty) {
        state = state.copyWith(searchError: 'ไม่มีร้านที่เปิดทำการในขณะนี้');
        return;
      }
    }

    List<PharmacyInfoResponse>? searchPharmacyInfoList;

    // เริ่ม filter
    searchPharmacyInfoList =
        (!openPharmacy ? pharmacyInfoList : _pharmacyInfoList).where(
      (e) {
        // ประกาศตัวแปรเพื่อใช้เช็ดว่าค้นหาเจอหรือไม่
        bool hasName = false;
        bool hasDistance = false;
        bool hasReviewScore = false;
        bool hasCountReviewer = false;
        double myLatitude = state.myLatitude ?? 0.0;
        double myLongtitude = state.myLongtitude ?? 0.0;

        // ถ้าชื่อที่ต้องการค้นหาไม่เป็น null หรือว่างให้เริ่มเช็ด
        // ว่าชื่อที่ filter มีชื่อคล้ายกับร้านในในระบบบ้าง
        // ถ้ามีการให้ hasName เป็น true
        if (name != null && name.isNotEmpty) {
          final _name = e.nameStore!.toLowerCase();
          hasName = _name.contains(
            name,
          );
        }

        // ถ้าระยะที่ต้องการค้นหาไม่เป็น null
        // เช็ดว่าระยะทางที่ filter มีระยะทางตามเงื่อนไข
        // ถ้ามีการให้ hasDistance เป็น true
        if (distance != null && distance > 0) {
          double _distance = Geolocator.distanceBetween(
                myLatitude,
                myLongtitude,
                e.latitude ?? 0.0,
                e.longtitude ?? 0.0,
              ) /
              1000.0;

          hasDistance = _distance <= distance;
        }

        // ถ้าคะแนนรีวิวที่ต้องการค้นหาไม่เป็น null
        // เช็ดว่าคะแนนรีวิวที่ filter มีคะแนนรีวิวตามเงื่อนไข
        // ถ้ามีการให้ hasReviewScore เป็น true
        // if (reviewScore != null) {
        //   hasReviewScore = (e.ratingScore ?? 0) >= int.parse(reviewScore.value);
        // }
        if (reviewScore != null) {
          if ((int.parse(reviewScore.value)) == 1) {
            hasReviewScore =
                (e.ratingScore ?? 0) >= 1 && (e.ratingScore ?? 0) < 2;
          } else if ((int.parse(reviewScore.value)) == 2) {
            hasReviewScore =
                (e.ratingScore ?? 0) >= 2 && (e.ratingScore ?? 0) < 3;
          } else if ((int.parse(reviewScore.value)) == 3) {
            hasReviewScore =
                (e.ratingScore ?? 0) >= 3 && (e.ratingScore ?? 0) < 4;
          } else if ((int.parse(reviewScore.value)) == 4) {
            hasReviewScore =
                (e.ratingScore ?? 0) >= 4 && (e.ratingScore ?? 0) < 5;
          } else if ((int.parse(reviewScore.value)) == 5) {
            hasReviewScore = (e.ratingScore ?? 0) == 5;
          } else {
            hasReviewScore =
                (e.ratingScore ?? 0) == int.parse(reviewScore.value);
          }
        }

        // ถ้าคนรีวิวที่ต้องการค้นหาไม่เป็น null
        // เช็ดว่าคนรีวิวที่ filter มีคนรีวิวตามเงื่อนไข
        // ถ้ามีการให้ hasReviewScore เป็น true
        // if (countReviewer != null) {
        //   hasCountReviewer = (e.countReviewer ?? 0) >= countReviewer;
        // }
        if (countReviewer != null) {
          if (countReviewer == 0) {
            hasCountReviewer = (e.countReviewer ?? 0) == countReviewer;
          } else {
            hasCountReviewer = (e.countReviewer ?? 0) >= countReviewer;
          }
        }

        // ถ้าชื่อที่ต้องการค้นหาไม่เป็น null หรือว่าง และ hasName เป็น false ให้ error message เป็นตามนี้
        if (name != null && name.isNotEmpty && !hasName) {
          state = state.copyWith(searchError: 'ค้นหาด้วยชื่อไม่เจอ');
        }

        // ถ้าคะแนนที่ต้องการค้นหาไม่เป็น null และ hasReviewScore เป็น false ให้ error message เป็นตามนี้
        if (reviewScore != null && !hasReviewScore) {
          state = state.copyWith(searchError: 'ค้นหาด้วยคะแนนรีวิวไม่เจอ');
        }

        // ถ้าคนรีวิวที่ต้องการค้นหาไม่เป็น null และ hasCountReviewer เป็น false ให้ error message เป็นตามนี้
        if (countReviewer != null && !hasCountReviewer) {
          state = state.copyWith(searchError: 'ค้นหาด้วยจำนวนคนรีวิวไม่เจอ');
        }

        // ถ้าระยะทางที่ต้องการค้นหาไม่เป็น null และ hasDistance เป็น false ให้ error message เป็นตามนี้
        if ((distance != null && distance > 0) && !hasDistance) {
          state = state.copyWith(searchError: 'ค้นหาด้วยระยะทางไม่เจอ');
        }

        // เงื่อนกรณี filter พร้อมกันหลายแบบ
        //ชื่ออย่างเดียว
        if (name != null &&
            name.isNotEmpty &&
            reviewScore == null &&
            countReviewer == null &&
            (distance == null || distance == 0)) {
          return hasName;
          //ชื่อกับคะแนนรีวิว
        } else if (name != null &&
            name.isNotEmpty &&
            reviewScore != null &&
            countReviewer == null &&
            (distance == null || distance == 0)) {
          return hasName && hasReviewScore;
          //ชื่อกับจำนวนคน
        } else if (name != null &&
            name.isNotEmpty &&
            reviewScore == null &&
            countReviewer != null &&
            (distance == null || distance == 0)) {
          return hasName && hasCountReviewer;
          //ชื่อกับระยะทาง
        } else if (name != null &&
            name.isNotEmpty &&
            reviewScore == null &&
            countReviewer == null &&
            (distance != null && distance > 0)) {
          return hasName && hasDistance;
          //ชื่อ ระยะทาง จำนวน คะแนน
          // } else if (name != null &&
          //     name.isNotEmpty &&
          //     reviewScore != null &&
          //     countReviewer != null &&
          //     (distance != null && distance > 0)) {
          //   return hasName && hasReviewScore && hasCountReviewer && hasDistance;
          //คะแนนรีวิว
        } else if ((name == null || name.isEmpty) &&
            reviewScore != null &&
            countReviewer == null &&
            (distance == null || distance == 0)) {
          return hasReviewScore;
          //คะแนน จำนวน ระยะทาง
        } else if ((name == null || name.isEmpty) &&
            reviewScore != null &&
            countReviewer != null &&
            (distance != null && distance > 0)) {
          return hasReviewScore && hasCountReviewer && hasDistance;
          //คะแนน จำนวน
        } else if ((name == null || name.isEmpty) &&
            reviewScore != null &&
            countReviewer != null &&
            (distance == null || distance == 0)) {
          return hasReviewScore && hasCountReviewer;
          //คะแนน ระยะทาง
        } else if ((name == null || name.isEmpty) &&
            reviewScore != null &&
            countReviewer == null &&
            (distance != null && distance > 0)) {
          return hasReviewScore && hasDistance;
          //จำนวน
        } else if ((name == null || name.isEmpty) &&
            reviewScore == null &&
            countReviewer != null &&
            (distance == null || distance == 0)) {
          return hasCountReviewer;
          //จำนวน ระยะทาง
        } else if ((name == null || name.isEmpty) &&
            reviewScore == null &&
            countReviewer != null &&
            (distance != null && distance > 0)) {
          return hasCountReviewer && hasDistance;
          //ระยะทาง
        } else if ((name == null || name.isEmpty) &&
            reviewScore == null &&
            countReviewer == null &&
            (distance != null && distance > 0)) {
          return hasDistance;
        }

        if (!hasName && !hasDistance && !hasReviewScore && !hasCountReviewer) {
          return openPharmacy;
        }

        // default
        return hasName && hasDistance && hasReviewScore && hasCountReviewer;
      },
    ).toList();

    state = state.copyWith(
      searchPharmacyInfoList: searchPharmacyInfoList,
    );
  }

  void onSetSearchDistance(
    int? distance,
  ) async {
    state = state.copyWith(
      searchDistance: distance,
    );
  }

  void onSetSearchRaiting(
    SwitchButtonItem<dynamic>? rating,
  ) async {
    state = state.copyWith(
      searchReviewScore: rating,
    );
  }

  void onSetSearchCountReviewer(
    int? countReviewer,
  ) async {
    state = state.copyWith(
      searchCountReviewer: countReviewer,
    );
  }

  void onSetSearchOpeningTime(
    String? openingTime,
  ) async {
    state = state.copyWith(
      searchOpeningTime: openingTime,
    );
  }

  void onSetSearchOpenPharmarcy(
    bool timeOpen,
  ) async {
    state = state.copyWith(
      searchTimeOpen: timeOpen,
    );
  }

  void onSetSearchClosingTime(
    String? closingTime,
  ) async {
    state = state.copyWith(
      searchClosingTime: closingTime,
    );
  }

  void onClearSearch() async {
    state = state.copyWith(
      searchDistance: null,
      searchReviewScore: null,
      searchCountReviewer: null,
      searchOpeningTime: null,
      searchClosingTime: null,
      searchTimeOpen: false,
      searchPharmacyInfoList: null,
    );
  }

  void onSelectedPharmacyStore(PharmacyInfoResponse result) async {
    state = state.copyWith(
      selectPharmacyInfoResponse: result,
    );
  }

  void onClearSelectedPharmacyStore() async {
    state = state.copyWith(
      selectPharmacyInfoResponse: null,
    );
  }

  void onClearError() async {
    state = state.copyWith(
      searchError: null,
    );
  }
}
