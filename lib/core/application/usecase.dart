import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:pharmacy_online/core/error/failure.dart';

/// คลาสแบบนามธรรมที่แทน UseCase ในแอปพลิเคชัน
/// มันให้วิธีที่มีโครงสร้างเพื่อจัดการและติดต่อกับข้อมูล
abstract class UseCase<P, R> {
  set ref(Ref ref) {}

  // Logger สำหรับการติดตามการทำงานของ UseCase
  Logger? _logger;

  /// เมธอดสำหรับ Logger ซึ่งจะสร้าง Logger ใหม่หากยังไม่มี
  Logger get logger {
    if (_logger != null) {
      return _logger!;
    }
    _logger = Logger(runtimeType.toString());
    return _logger!;
  }

  /// เมธอดที่ได้รับความคาดหวังที่ต้องถูกนำมาใช้ในคลาสย่อยเพื่อดำเนินการหลักของ UseCase
  @protected
  Future<R> exec(P request);

  /// เมธอดในการทำ UseCase และจัดการกับผลลัพธ์
  Future<Result<R, Failure>> execute(P request) async {
    try {
      // เรียกใช้เมธอด exec เพื่อทำ UseCase
      final result = await exec(request);
      return Success(result);
    } on FirebaseException catch (e) {
      // จัดการข้อผิดพลาดที่เกิดขึ้นในกรณีของ FirebaseException
      return Error(
        Failure(
          message: e.message ?? '',
        ),
      );
    }
  }
}
