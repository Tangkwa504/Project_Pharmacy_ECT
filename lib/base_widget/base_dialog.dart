import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

/// ฟังก์ชันสำหรับแสดง base dialog.
Future<T?> showBaseDialog<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool barrierDismissible = true,
}) {
  return showDialog(
    context: context,
    builder: builder,
    barrierColor: AppColor.themeGrayLight,
    barrierDismissible: barrierDismissible,
  );
}

/// Widget ที่แทนที่ base dialog แก้ไขได้
class BaseDialog extends StatelessWidget {
  final String? message;
  final VoidCallback? onClick;
  final bool willPopScope;
  final Widget? dialogLogo;
  final bool hasCancel;

  /// Constructor สำหรับกำหนดค่า BaseDialog.
  BaseDialog({
    Key? key,
    this.message,
    this.onClick,
    this.willPopScope = false,
    this.dialogLogo,
    this.hasCancel = false,
  }) : super(key: key);

  //ส่วนมุมโค้งของ dialog
  final ShapeBorder shapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => willPopScope,
      child: Dialog(
        elevation: 0,
        shape: shapeBorder,
        clipBehavior: Clip.antiAlias,
        backgroundColor: AppColor.themeWhiteColor,
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: width - 16 * 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 24.0, 30.0, 16),
            child: SizedBox(
              width: width - 16 * 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dialogLogo != null) ...[
                    dialogLogo!,
                  ],
                  SizedBox(
                    height: 28.h,
                  ),
                  if (message != null) ...[
                    Text(
                      '$message',
                      textAlign: TextAlign.center,
                      style: AppStyle.txtBody2,
                    ),
                  ],
                  SizedBox(
                    height: 24.h,
                  ),
                  BaseButton(
                    onTap: onClick ??
                        () {
                          final navigator =
                              Navigator.of(context, rootNavigator: true);
                          if (navigator.canPop()) {
                            navigator.pop(true);
                          }
                        },
                    width: 80.w,
                    text: 'ยืนยัน',
                  ),
                  if (hasCancel) ...[
                    SizedBox(
                      height: 8.h,
                    ),
                    BaseButton(
                      buttonType: ButtonType.tertiary,
                      onTap: () {
                        final navigator =
                            Navigator.of(context, rootNavigator: true);
                        if (navigator.canPop()) {
                          navigator.pop(false);
                        }
                      },
                      width: 80.w,
                      text: 'ยกเลิก',
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
