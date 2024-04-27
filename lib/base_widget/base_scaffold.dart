import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_loading_dialog.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';

class BaseScaffold extends ConsumerWidget {
  final Widget Function(BuildContext, BoxConstraints) bodyBuilder;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final PreferredSizeWidget? appBar;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final Color? bgColor;
  final bool isSafeBottom;
  final bool isSafeTop;
  final bool hasAppBar;
  final bool isAppearBottomBarWhenKeyboardShowing;
  final bool isWillPop;
  final Widget? floatingActionButton;

  // Constructor สำหรับการสร้าง BaseScaffold
  const BaseScaffold({
    Key? key,
    required this.bodyBuilder,
    this.bgColor,
    this.appBar,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.isSafeBottom = true,
    this.isSafeTop = true,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.hasAppBar = false,
    this.isAppearBottomBarWhenKeyboardShowing = false,
    this.isWillPop = true,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ตรวจสอบว่ามี Loading หรือไม่
    final isLoading = ref.watch(
      loaderControllerProvider.select(
        (value) => value,
      ),
    );

    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async => isWillPop,
          child: Scaffold(
            bottomNavigationBar: Padding(
              padding: isAppearBottomBarWhenKeyboardShowing
                  ? MediaQuery.of(context).viewInsets.w
                  : EdgeInsets.zero,
              child: bottomNavigationBar,
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // for remove primary focus and trigger the keyboard to dismiss.
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SafeArea(
                bottom: isSafeBottom,
                top: isSafeTop,
                child: LayoutBuilder(
                  builder: bodyBuilder,
                ),
              ),
            ),
            appBar: appBar,
            backgroundColor: bgColor ?? AppColor.themeWhiteColor,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            bottomSheet: bottomSheet,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startDocked,
          ),
        ),
        // แสดง Loading Modal ถ้ามี isLoading
        if (isLoading)
          LoadingDialogModal.asyncLoading(
            isLoading: isLoading,
          ),
      ],
    );
  }
}
