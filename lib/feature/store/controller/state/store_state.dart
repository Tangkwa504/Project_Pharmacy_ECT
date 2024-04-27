import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_switch_button.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/model/response/reviews_response.dart';

part 'store_state.freezed.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({
    BaseFormData? baseFormData,
    String? errMsg,
    @Default(AsyncValue.loading())
    AsyncValue<List<MedicineResponse>?> centralMedicineList,
    @Default(AsyncValue.loading())
    AsyncValue<List<MedicineResponse>?> medicineList,
    @Default(AsyncValue.loading())
    AsyncValue<List<PharmacyInfoResponse>?> pharmacyInfoList,
    double? myLongtitude,
    double? myLatitude,
    @Default(AsyncValue.loading())
    AsyncValue<List<ChatWithPharmacyResponse>?> chatWithPharmacyList,
    @Default(AsyncValue.loading())
    AsyncValue<PharmacyInfoResponse?> pharmacyDetail,
    @Default(AsyncValue.loading())
    AsyncValue<List<ReviewsResponse>?> reviewList,
    @Default(AsyncValue.loading())
    AsyncValue<List<CommentResponse>?> commentList,
    @Default(false) bool checkRequestChatAlready,
    @Default(false) bool checkRequestChatWaiting,
    List<MedicineResponse>? searchCentralMedicineList,
    List<MedicineResponse>? searchMedicineList,
    List<PharmacyInfoResponse>? searchPharmacyInfoList,
    int? searchDistance,
    SwitchButtonItem<dynamic>? searchReviewScore,
    @Default(false) bool searchTimeOpen,
    int? searchCountReviewer,
    String? searchOpeningTime,
    String? searchClosingTime,
    PharmacyInfoResponse? selectPharmacyInfoResponse,
    String? searchError,
  }) = _StoreState;
}
