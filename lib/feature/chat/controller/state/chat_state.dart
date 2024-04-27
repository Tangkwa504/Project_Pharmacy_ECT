import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    BaseFormData? baseFormData,
    String? errMsg,
    @Default(AsyncValue.loading())
    AsyncValue<List<ChatWithPharmacyResponse>?> chatWithPharmacyList,
    @Default(AsyncValue.loading())
    AsyncValue<List<ChatWithPharmacyResponse>?> messageList,
  }) = _ChatState;
}
