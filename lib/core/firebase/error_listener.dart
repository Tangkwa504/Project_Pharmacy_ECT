import 'dart:isolate';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// To catch errors that happen outside of the Flutter context,
/// install an error listener on the current Isolate:
/// record the exception to FirebaseCrashlytics

Future<void> errorListener() async {
  //only log when crash collection is enabled
  if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
    // เพิ่ม Error Listener บน Isolate ปัจจุบัน
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        // บันทึกข้อผิดพลาดลง FirebaseCrashlytics
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
        );
      }).sendPort,
    );
  }
}
