import 'package:flutter/material.dart';

/// Solution from stack overflow
/// https://stackoverflow.com/questions/50115311/flutter-how-to-force-an-application-restart-in-production-mode

/// Widget ที่ใช้สำหรับรีสตาร์ทแอปพลิเคชัน Flutter
/// โดยจะสร้าง Key ใหม่เมื่อมีการรีสตาร์ทแอปพลิเคชัน
class RestartWidget extends StatefulWidget {
  final Widget child;
  const RestartWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// เรียกใช้เมื่อต้องการรีสตาร์ทแอปพลิเคชัน
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  /// เมื่อต้องการรีสตาร์ทแอปพลิเคชัน
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
