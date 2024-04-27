import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// สร้าง Provider ของ Analytics เพื่อให้สามารถใช้งาน Firebase Analytics ได้ทั่วทั้งแอป
final firebaseAnalyticsProvider = Provider<Analytics>((ref) {
  // สร้างและคืนค่าอ็อบเจ็กต์ของ Analytics ที่ใช้ FirebaseAnalytics.instance
  return Analytics(FirebaseAnalytics.instance);
});

/// This is a wrapper class for FirebaseAnalytics
class Analytics {
  final FirebaseAnalytics _firebaseAnalytics;

  Analytics(this._firebaseAnalytics);

  // Set [userId]
  Future<void> setUserId({required String userId}) async {
    await _firebaseAnalytics.setUserId(id: userId);
  }

  // Set user properties. Up to 25 user property names are supported
  Future<void> setUserProperties(
      {required String name, required String value}) async {
    await _firebaseAnalytics.setUserProperty(name: name, value: value);
  }

  // Log a custom event
  Future<void> logEvent(
      {required String name, Map<String, Object>? param}) async {
    await _firebaseAnalytics.logEvent(
      name: name,
      parameters: param,
    );
  }

  // Logs that the application has been opened.
  Future<void> logAppOpen() async {
    await _firebaseAnalytics.logAppOpen();
  }

  // Screen tracking
  Future<void> logCurrentScreen({required String screenName}) async {
    await _firebaseAnalytics.setCurrentScreen(screenName: screenName);
  }

  // Set the duration of inactivity that terminates the current session.
  // Please note that this API is android only.
  Future<void> setSessionTimeOutDuration({required int duration}) async {
    await _firebaseAnalytics
        .setSessionTimeoutDuration(Duration(minutes: duration));
  }

  // To clear all data associated with the current session
  // เพื่อล้างข้อมูลทั้งหมดที่เกี่ยวข้องกับเซสชันปัจจุบัน
  Future<void> resetAnalyticDate() async {
    await _firebaseAnalytics.resetAnalyticsData();
  }

  ///When a user is presented with a list of results, log a view_item_list event including an items array parameter containing the displayed products.
  Future<void> logItemListView(
      {required String id,
      required String listName,
      required List<AnalyticsEventItem> items}) async {
    await _firebaseAnalytics.logViewItemList(
      itemListId: id,
      itemListName: listName,
      items: items,
    );
  }

  ///Once a user selects a particular product from the list, log a select_item event with the chosen product in an items array parameter.
  Future<void> logItemSelected(
      {required String id,
      required String listName,
      required List<AnalyticsEventItem> items}) async {
    await _firebaseAnalytics.logSelectItem(
      itemListId: id,
      itemListName: listName,
      items: items,
    );
  }

  Future<void> logItemView(
      {required String currency,
      required double value,
      required List<AnalyticsEventItem> items}) async {
    await _firebaseAnalytics.logViewItem(
      currency: currency,
      value: value,
      items: items,
    );
  }
}
