import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

class RowTextClickableWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String label1;
  final String label2;

  const RowTextClickableWidget({
    super.key,
    required this.onTap,
    required this.label1,
    required this.label2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label1,
          style: AppStyle.txtCaption,
        ),
        SizedBox(
          width: 4.w,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            label2,
            style: AppStyle.txtCaption.copyWith(
              color: AppColor.hyperLinkColor,
            ),
          ),
        ),
      ],
    );
  }
}
