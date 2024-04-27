import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:pharmacy_online/core/widget/connectivity_provider.dart';
import 'package:rxdart/rxdart.dart';

// BaseConsumerState เป็นคลาสหลักที่ถูกใช้เป็นฐานสำหรับ StatefulWidget ในแอปพลิเคชัน
abstract class BaseConsumerState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> with RestorationMixin<T>, WidgetsBindingObserver {
  // CompositeSubscription เป็นอ็อบเจ็กต์จัดการการ subscribe หลาย ๆ Stream
  CompositeSubscription get compositeSubscription => CompositeSubscription();

  // Logger เป็นอ็อบเจ็กต์สำหรับ logging ที่ใช้ชื่อของคลาส T
  Logger get log => Logger(T.toString());

  @override
  void initState() {
    super.initState();
    log.info('initState');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    compositeSubscription.dispose();
    log.info('dispose');
    super.dispose();
  }

  @override
  String? get restorationId => T.toString();

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO(richard): override from child class.
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // เมธอด initConnectivity ใช้สำหรับตรวจสอบสถานะการเชื่อมต่อของอุปกรณ์
  Future<ConnectivityResult> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // ลองดึงข้อมูลสถานะการเชื่อมต่อผ่าน ConnectivityProvider
    try {
      final connectivity = ref.read(connectivityProvider);
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log.info('Couldn\'t check connectivity status', e);
    }

    return result;
  }

  // Check for network connection
  // เมธอด checkNetworkConnection ใช้สำหรับตรวจสอบการเชื่อมต่อเครือข่าย
  void checkNetworkConnection() async {
    final result = await initConnectivity();
    if (result == ConnectivityResult.mobile) {
      // มีการเชื่อมต่อผ่านมือถือ
      return;
    } else if (result == ConnectivityResult.wifi) {
      // มีการเชื่อมต่อผ่าน WiFi
      return;
    } else {
      if (!mounted) return;
      // ไม่มีการเชื่อมต่อ
      // TODO: redirect to connection error screen
      // Navigator.pushNamed(context, connectionErrorRoute);
    }
  }
}
