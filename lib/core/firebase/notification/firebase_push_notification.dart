import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/firebase/notification/firebase_backgroung_messaaging.dart';
import 'package:pharmacy_online/core/firebase/notification/local_notification.dart';
import 'package:pharmacy_online/core/firebase/notification/model/received_notification.dart';

final firebasePushNotificationProvider =
    Provider.autoDispose<FirebasePushNotification>((ref) {
  final localNotification = ref.watch(localNotificationProvider);

  return FirebasePushNotification(
    messaging: FirebaseMessaging.instance,
    localNotification: localNotification,
    ref: ref,
  );
});

/// Class ที่ใช้จัดการกับ Firebase Cloud Messaging (FCM) และ Local Notification
class FirebasePushNotification {
  final FirebaseMessaging messaging;
  final LocalNotification localNotification;
  final Ref ref;

  FirebasePushNotification({
    required this.messaging,
    required this.localNotification,
    required this.ref,
  }) {
    _init();
  }

  /// ฟังก์ชันเริ่มต้นการตั้งค่า Firebase Cloud Messaging (FCM)
  void _init() async {
    // On iOS, macOS & web, before FCM payloads can be received on your device,
    // you must first ask the user's permission.
    // Android applications are not required to request permission.
    // ขออนุญาตการแจ้งเตือนจากระบบ
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // ตรวจสอบว่าผู้ใช้ได้อนุญาตไหม
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    // Foreground notifications (also known as "heads up") are those which
    // display for a brief period of time above existing applications,
    // and should be used for important events.
    // iOS Configuration
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // Set the background messaging handler early on, as a named top-level function
    // ตั้งค่าการจัดการข้อความเมื่อแอปพลิเคชันทำงานใน background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// If your own application is in the foreground, the Firebase Android SDK will block displaying any FCM notification
  /// no matter what Notification Channel has been set. We can however still handle an incoming notification message
  /// via the onMessage stream and create a custom local notification using flutter_local_notifications:
  void onFirebaseMessageReceived() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> data = message.data;

      if (notification != null && android != null) {
        // แสดง Local Notification ด้วยข้อมูลที่ได้รับ
        localNotification.showNotification(
          ReceivedNotification(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            payload: jsonEncode(data),
            imageUrl: android.imageUrl,
          ),
        );
      }
    });
  }

  /// Get firebase token
  Future<String?> getFirebaseToken() async {
    return await messaging.getToken();
  }

  /// Get notification setting for iOS
  Future<NotificationSettings?> getNotificationSettings() async {
    return await messaging.getNotificationSettings();
  }

  /// The default behavior on both Android & iOS is to open the application.
  /// If the application is terminated it will be started,
  /// if it is in the background it will be brought to the foreground.
  /// Depending on the content of a notification,
  /// you may wish to handle the users interaction when the application opens.
  ///
  // It is assumed that all messages contain a data field with the key 'type'

  /// ฟังก์ชันตั้งค่าการจัดการเมื่อผู้ใช้คลิกที่ Notification
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await messaging.getInitialMessage();

    // If the message also contains a data property with a "type" of "product",
    // navigate to a product screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  // TODO(richard): change the logic to handle remote message
  /// Listen to firebase push notification click listener
  void _handleMessage(RemoteMessage message) {
    if (message.data['link'] != null) {
      final String link = message.data['link'];
      // ref.read(goRouterProvider).go(link);
    }
  }
}
