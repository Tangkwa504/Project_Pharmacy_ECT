import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

enum ButtonType { primary, secondary, tertiary, danger, success }

class BaseButton extends StatelessWidget {
  final ButtonType buttonType;
  final bool fitContent;
  final double? minWidth;
  final double? width;
  final Color? color;
  final double borderRadius;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final String? text;
  final Widget? iconWidget;
  final MainAxisAlignment rowMainAxisAlignment;
  final Color? txtColor;
  final EdgeInsets? margin;
  final bool isEnable;

  // คอนสตรักเตอร์ที่ใช้รับค่าต่าง ๆ ที่จำเป็นสำหรับการสร้าง Button
  const BaseButton({
    Key? key,
    this.buttonType = ButtonType.primary,
    this.fitContent = true,
    this.minWidth,
    this.width,
    this.color,
    this.borderRadius = 8.0,
    required this.onTap,
    this.padding = const EdgeInsets.all(8.0),
    this.textStyle,
    this.text,
    this.iconWidget,
    this.rowMainAxisAlignment = MainAxisAlignment.center,
    this.txtColor,
    this.margin,
    this.isEnable = true,
  }) : super(key: key);

  // กำหนดสีขอบของ Button
  Color _getBorderColor() {
    if (!isEnable) {
      return AppColor.themeGrayLight;
    }

    switch (buttonType) {
      case ButtonType.danger:
        return AppColor.errorColor;
      case ButtonType.tertiary:
        return AppColor.themePrimaryColor;
      case ButtonType.secondary:
        return AppColor.themeYellowColor;
      case ButtonType.success:
        return AppColor.themePrimaryColor;
      case ButtonType.primary:
      default:
        return AppColor.themePrimaryColor;
    }
  }

// กำหนดสีพื้นหลังของ Button
  Color _getButtonColor() {
    if (!isEnable) {
      return AppColor.themeGrayLight;
    }

    switch (buttonType) {
      case ButtonType.danger:
        return AppColor.errorColor;
      case ButtonType.tertiary:
        return AppColor.themeWhiteColor;
      case ButtonType.secondary:
        return AppColor.themeYellowColor;
      case ButtonType.success:
        return AppColor.themePrimaryColor;
      case ButtonType.primary:
      default:
        return AppColor.themePrimaryColor;
    }
  }

// กำหนดสีของ Text บน Button
  Color _getButtonTextColor() {
    if (!isEnable) {
      return AppColor.themeWhiteColor;
    }

    switch (buttonType) {
      case ButtonType.danger:
        return AppColor.themeWhiteColor;
      case ButtonType.tertiary:
        return AppColor.themePrimaryColor;
      case ButtonType.secondary:
        return AppColor.themeWhiteColor;
      case ButtonType.primary:
      default:
        return AppColor.themeWhiteColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    // คำนวณขนาดของ Button ตามตัวเลือกที่กำหนด
    final minWidth = this.minWidth ?? 0;
    final width = this.width;
    final hasIcon = iconWidget != null;
    final hasText = text != null;

    return Container(
      constraints: fitContent
          ? BoxConstraints(
              minWidth: minWidth,
            )
          : null,
      width: width,
      margin: margin,
      child: Container(
        // กำหนดรูปแบบการแสดงผลของ Button
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? _getBorderColor(),
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          color: color ?? _getButtonColor(),
        ),
        child: Material(
          color: color ?? _getButtonColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          // กำหนด InkWell เพื่อให้สามารถรับ Event การ Tap
          child: InkWell(
            onTap: isEnable
                ? onTap
                : null, // ตรวจสอบว่า Button ได้เปิดใช้งานหรือไม่
            splashColor: Colors.transparent, // สีที่แสดงขณะแตะ
            highlightColor: Colors.transparent, // สีที่เน้นขณะแตะ (ถ้ามี)
            hoverColor: Colors.transparent, // สีที่แสดงขณะเมาส์วาง
            borderRadius:
                BorderRadius.circular(borderRadius), // กำหนดรูปร่างของขอบ
            child: Container(
              padding: padding,
              child: Row(
                mainAxisAlignment: rowMainAxisAlignment,
                children: [
                  // ตรวจสอบว่ามี Icon ใน Button หรือไม่
                  if (hasIcon) ...[
                    iconWidget!,
                  ],
                  // ตรวจสอบว่ามีทั้ง Icon และ Text ใน Button หรือไม่
                  if (hasIcon && hasText) ...[
                    SizedBox(
                      width: 8.0.w,
                    ),
                  ],
                  // ตรวจสอบว่ามี Text ใน Button หรือไม่
                  if (hasText) ...[
                    Flexible(
                      child: FittedBox(
                        fit: fitContent ? BoxFit.contain : BoxFit.none,
                        child: Text(
                          text!,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle ??
                              AppStyle.txtBody2.copyWith(
                                color: _getButtonTextColor(),
                              ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
