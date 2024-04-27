import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Constructor ของ Widget
  const BaseAppBar({
    Key? key,
    this.leading,
    this.leadingWidth,
    this.title,
    required this.bgColor,
    this.isCenterTitle,
    this.iconThemeData,
    this.elevation,
    this.actions,
    this.titleSpacing,
    this.hideBackButton = false,
    this.bottom,
  }) : super(key: key);

  final Widget? leading; // Widget ที่จะแสดงทางด้านซ้ายของ AppBar
  final double? leadingWidth; // กำหนดความกว้างของ leading widget
  final Widget? title; // Widget ที่จะแสดงเป็น title ของ AppBar
  final Color bgColor; // สีของ AppBar
  final bool? isCenterTitle; // กำหนดว่า title จะแสดงตรงกลางหรือไม่
  final IconThemeData? iconThemeData; // กำหนดรูปแบบ icon ทั้งหมดใน AppBar
  final double? elevation; // ความสูงของ AppBar
  final List<Widget>? actions; // Widget ที่จะแสดงทางด้านขวาของ AppBar
  final double? titleSpacing; // ระยะห่างระหว่าง title และ leading/actions
  final bool hideBackButton; // ซ่อนปุ่ม back หรือไม่
  final PreferredSizeWidget? bottom; // Widget ที่จะแสดงใต้ส่วนล่างของ AppBar

  // ตัวฟังก์ชัน build ที่ใช้สร้าง UI ของ Widget
  @override
  Widget build(BuildContext context) {
    Widget? _leading;

    // ถ้าไม่ได้กำหนด leading ให้ใช้ IconButton เป็นปุ่ม back
    if (leading == null) {
      _leading = IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 16.0,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      );
    }

    // สร้าง AppBar โดยใช้ค่าที่กำหนดใน constructor
    return AppBar(
      titleSpacing: titleSpacing?.w ?? 0,
      leading: hideBackButton ? Container() : leading ?? _leading,
      leadingWidth: hideBackButton ? 0 : leadingWidth?.w,
      title: Padding(
        padding: EdgeInsets.only(
          left: hideBackButton ? 16.w : 0,
        ),
        child: title,
      ),
      centerTitle: isCenterTitle ?? false,
      backgroundColor: bgColor,
      iconTheme: iconThemeData,
      actions: actions,
      elevation: elevation ?? 2,
      bottom: bottom,
    );
  }

  // คืนค่าขนาดที่ถูกต้องสำหรับ AppBar
  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height.h ?? 0.0),
      );
}
