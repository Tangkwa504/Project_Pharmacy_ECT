import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_online/core/application/custom_platform.dart';

// Enum ที่ใช้กำหนดประเภทของ animation ในการเปลี่ยนหน้าจอ
enum RouteTransition {
  defaultAnimation,
  fade,
  fadeThrough,
  fadeScale,
  none,
  slideVertically,
}

class CustomPageRouteBuilder {
  // Private constructor เพื่อป้องกันการสร้าง instance ของ class นี้
  CustomPageRouteBuilder._();

  // ฟังก์ชันที่สร้างและคืนค่า PageRoute ตามประเภทของ animation ที่กำหนด
  static PageRoute<T> _route<T>({
    required Widget Function(BuildContext) builder,
    String? name,
    Duration? transitionDuration,
    RouteTransition? transitionType,
  }) {
    // กำหนดประเภทของ animation ในกรณีที่ไม่ได้ระบุ
    final tType = transitionType ?? RouteTransition.defaultAnimation;

    // สร้างและคืนค่า PageRoute ตามประเภทของ animation
    if (tType == RouteTransition.defaultAnimation) {
      return MaterialPageRoute(
          builder: builder, settings: RouteSettings(name: name));
    }

    return PageRouteBuilder<T>(
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 300),
      pageBuilder: (context, _, __) => builder(context),
      settings: RouteSettings(name: name),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (tType) {
          case RouteTransition.fade:
            return FadeTransition(opacity: animation, child: child);

          case RouteTransition.fadeThrough:
            return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child);
          case RouteTransition.fadeScale:
            return FadeScaleTransition(animation: animation, child: child);

          case RouteTransition.slideVertically:
            // ตรวจสอบ platform ว่าเป็น iOS หรือไม่
            if (CustomPlatform.isIOS) {
              return CupertinoFullscreenDialogTransition(
                  primaryRouteAnimation: animation,
                  secondaryRouteAnimation: AlwaysStoppedAnimation(0),
                  linearTransition: false,
                  child: child);
            }
            // ใช้ SharedAxisTransition สำหรับ Android
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              child: child,
            );

          default:
            // ในกรณีที่ไม่ตรงกับเงื่อนไขใดเลยให้คืน child ไปเลย
            return child;
        }
      },
    );
  }

  // ฟังก์ชันสำหรับการเรียกใช้ Route โดยระบุ builder, name, duration, และประเภทของ animation
  static PageRoute route<T>({
    required Widget Function(BuildContext) builder,
    String? name,
    Duration? transitionDuration,
    RouteTransition? transitionType,
  }) {
    // เรียกใช้ฟังก์ชัน _route และส่งพารามิเตอร์ที่ได้รับ
    return CustomPageRouteBuilder._route<T>(
        name: name,
        builder: (ctx) {
          // สร้าง widget ด้วย builder
          var widget = builder(ctx);

          return widget;
        },
        transitionDuration: transitionDuration,
        transitionType: transitionType);
  }
}
