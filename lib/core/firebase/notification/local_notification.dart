import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/firebase/notification/model/received_notification.dart';

final localNotificationProvider =
    Provider.autoDispose<LocalNotification>((ref) {
  final localNotification = LocalNotification(
    FlutterLocalNotificationsPlugin(),
    ref,
  );

  return localNotification;
});

/// Class ที่ใช้จัดการกับ Local Notification
class LocalNotification {
  final FlutterLocalNotificationsPlugin _localNotificationPlugin;
  final Ref _ref;

  LocalNotification(this._localNotificationPlugin, this._ref) {
    _init();
  }

  /// Configure and setup  flutter local notification
  void _init() async {
    AndroidInitializationSettings initializationSettingsAndroid
        // pass the icon for push notification (android/app/main/res/drawable)
        = const AndroidInitializationSettings('ic_notification');

    // iOS permission which we already set in firebase messaging setup
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestCriticalPermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Create the channel on the Android device (if a channel with an id already exists, it will be updated):
    await _localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(highImportanceChannel());

    // Initialize local notification
    // await _localNotificationPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (details) {
    //     _handleMessage(details.payload);
    //   },
    // );
  }

  ///On Android, notification messages are sent to Notification
  ///Channels which are used to control how a notification is delivered.
  ///The default FCM channel used is hidden from users, however provides a "default" importance level.
  ///Heads up notifications require a "max" importance level.

  ///ฟังก์ชันแสดง Local Notification
  void showNotification(ReceivedNotification message) async {
    //final String largeIcon = await _base64EncodedImage(message.imageUrl ?? '');
    String? bigPicture;
    if (message.imageUrl != null) {
      bigPicture = await _base64EncodedImage(message.imageUrl ?? '');
    }

    await _localNotificationPlugin.show(
      message.id,
      message.title,
      message.body,
      NotificationDetails(
        android: _androidNotificationDetail(
          bigPicture != null
              ? BigPictureStyleInformation(
                  ByteArrayAndroidBitmap.fromBase64String(bigPicture),
                )
              : null,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.payload,
    );
  }

  // โค้ดสำหรับดึงรูปภาพจาก URL และแปลงเป็น Base64
  Future<String> _base64EncodedImage(String url) async {
    // final response = await Dio().get<List<int>>(url,
    //     options: Options(responseType: ResponseType.bytes));
    // final String base64Data = base64Encode(response.data ?? []);
    // return base64Data;
    return '';
  }

  // Android notification channel
  AndroidNotificationDetails _androidNotificationDetail(
    StyleInformation? styleInformation,
  ) =>
      AndroidNotificationDetails(
        '1001',
        'General Notification',
        channelDescription: 'General notification for app',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'General notification for app',
        channelShowBadge: true,
        styleInformation: styleInformation,
      );

  // Notification channel for Android only
  AndroidNotificationChannel highImportanceChannel() {
    return const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
  }

  // TODO(richard): change the logic to handle remote message
  /// Listen to firebase push notification click listener
  void _handleMessage(String? payload) {
    final Map<String, dynamic> data = jsonDecode(payload ?? "");
    if (data['link'] != null) {
      final String link = data['link'];
      // _ref.read(goRouterProvider).go(link);
    }
  }
}
