import 'package:flutter_riverpod/flutter_riverpod.dart';

// คลาส AsyncUtils มีเป้าหมายในการจัดการกับ AsyncValue ใน Riverpod
class AsyncUtils {
  // เมธอด merge ใช้สำหรับรวมข้อมูลจาก Iterable ของ AsyncValue เป็น AsyncValue ของ List<T>
  static AsyncValue<List<T>> merge<T>(
    Iterable<AsyncValue<T>> items,
  ) {
    // สร้าง List เพื่อเก็บข้อมูลที่ถูกสกัดมา
    final List<T> data = [];

    // วนลูปผ่าน AsyncValue แต่ละตัวใน Iterable
    for (final item in items) {
      if (item is AsyncLoading) {
        return AsyncLoading<List<T>>();
      }

      // กรณีที่เป็น AsyncError จะคืนค่า AsyncError<List<T>> พร้อม error และ stackTrace
      if (item is AsyncError) {
        return AsyncError<List<T>>(
          (item as AsyncError).error,
          (item as AsyncError).stackTrace,
        );
      }

      // กรณีที่เป็น AsyncData<T> จะเก็บค่า T ลงใน List
      if (item is AsyncData<T>) {
        data.add(item.value);
      }
    }

    // สร้าง AsyncData<List<T>> ด้วย List ที่ได้จากการสกัด
    return AsyncData<List<T>>(data);
  }
}

// Extension สำหรับ AsyncValue ที่ให้เมธอด unwrap เพื่อดึงค่าจาก AsyncValue โดยระบุค่าเริ่มต้น
extension Unwrap<T> on AsyncValue<T> {
  T unwrap([T? defaultValue]) {
    // เรียกใช้ maybeWhen เพื่อเลือกส่วนของค่าข้อมูลหรือคืนค่าเริ่มต้น
    return maybeWhen(data: (data) => data, orElse: () => defaultValue!);
  }
}
