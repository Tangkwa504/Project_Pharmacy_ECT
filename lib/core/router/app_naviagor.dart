import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provide DeviceInfoPlugin instance
final appNavigatorProvider = Provider<AppNavigator>((ref) {
  return AppNavigator();
});

/// คลาส AppNavigator ที่ให้บริการฟังก์ชันการนำทางในแอปพลิเคชัน
class AppNavigator {
  final navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _currentState => navigatorKey.currentState!;

  /// ฟังก์ชันนำทางไปยังหน้าที่ระบุด้วยชื่อ route
  @optionalTypeArgs
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _currentState.pushNamed<T>(routeName, arguments: arguments);
  }

  /// ฟังก์ชันนำทางและแทนที่หน้าปัจจุบันด้วยหน้าที่ระบุด้วยชื่อ route
  @optionalTypeArgs
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _currentState.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  /// ฟังก์ชันนำทางและลบหน้าปัจจุบันและทุกหน้าที่ไม่ตรงเงื่อนไขออกจาก stack จนกว่าเงื่อนไขจะเป็นจริง
  @optionalTypeArgs
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _currentState.pushNamedAndRemoveUntil(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  /// ฟังก์ชันปิดหน้าปัจจุบันและส่งค่า result กลับ (ถ้ามี)
  @optionalTypeArgs
  void pop<T extends Object?>([T? result]) {
    _currentState.pop<T>(result);
  }

  /// ฟังก์ชันปิดหน้าจนกว่าเงื่อนไขจะเป็นเท็จ
  void popUntil(RoutePredicate predicate) {
    _currentState.popUntil(predicate);
  }

  /// ฟังก์ชันตรวจสอบว่าสามารถปิดหน้าได้หรือไม่
  bool canPop() {
    return _currentState.canPop();
  }
}
