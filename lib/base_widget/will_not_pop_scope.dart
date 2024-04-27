import 'package:flutter/material.dart';

/// Widget that when use it will can't pop navigator  by pressing back button.
/// Need to call navigator pop by code only.
class WillNotPopScope extends StatelessWidget {
  final Widget child;

  const WillNotPopScope({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: child,
    );
  }
}


///โค้ดข้างต้นเป็น Flutter Widget ที่ชื่อ WillNotPopScope ซึ่งถูกออกแบบมาเพื่อป้องกันการ pop ของ Navigator เมื่อกดปุ่ม back บนอุปกรณ์. 
///การนำ WillNotPopScope ไปใช้จะทำให้ไม่สามารถใช้ปุ่ม back บนอุปกรณ์ได้ และการ navigate ต้องควบคุมได้จากโค้ดเท่านั้น.