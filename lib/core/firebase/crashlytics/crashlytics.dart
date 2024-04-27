import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseCrashlyticsProvider = Provider<Crashlytics>((ref) {
  return Crashlytics(FirebaseCrashlytics.instance);
});

//// this is a wrapper class for FirebaseCrashlytics.
/// Crashlytics เป็นบริการตรวจจับและแจ้งเตือน Crash
class Crashlytics {
  final FirebaseCrashlytics _crashlytics;

  Crashlytics(this._crashlytics) {
    _init();
  }

  /// Enable or disable the Firebase crash collection
  void _init() async {
    // Check for debug mode
    if (kDebugMode) {
      // disable / enable the crashlytics in debug mode
      await _crashlytics.setCrashlyticsCollectionEnabled(false);
    } else {
      // disable / enable the crashlytics in release mode
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
    }
  }

  // To add user IDs to your reports, assign each user with a unique ID.
  Future<void> setUser(String user) async {
    await _crashlytics.setUserIdentifier(user);
  }

  //To add custom Crashlytics log messages to your app, use the log method
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  /// If you would like to record a fatal error, you may pass in a [fatal] argument as [true].
  /// The crash report will appear in your Crashlytics dashboard with the event type Crash,
  /// the event summary stack trace will also be referenced as a Fatal Exception.
  Future<void> fatalCrash(
      {required dynamic exception,
      required StackTrace stack,
      String? reason}) async {
    // only log when crash collection is enabled
    if (_crashlytics.isCrashlyticsCollectionEnabled) {
      await _crashlytics.recordError(
        exception,
        stack,
        reason: reason ?? 'Fatal Error',
        fatal: true,
      );
    }
  }

  /// By default non-fatal errors are recorded.
  /// The crash report will appear in your Crashlytics dashboard with the event type Non-fatal,
  ///the event summary stack trace will also be referenced as a Non-fatal Exception
  Future<void> nonFatalCrash(
      {required dynamic exception, StackTrace? stack, String? reason}) async {
    // only log when crash collection is enabled
    if (_crashlytics.isCrashlyticsCollectionEnabled) {
      await _crashlytics.recordError(
        exception,
        stack,
        reason: reason ?? 'Non-Fatal Error',
      );
    }
  }
}
