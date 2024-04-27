import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/feature/home/model/response/notification_response.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    String? errMsg,
    @Default(AsyncValue.loading())
    AsyncValue<List<NotificationResponse>?> notificationList,
  }) = _HomeState;
}
