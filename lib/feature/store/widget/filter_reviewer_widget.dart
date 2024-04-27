import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class FilterReviewerWidget extends StatefulWidget {
  final int maximum;
  final Function(int reviewer) onUpdate;
  final int? initial;

  // พารามิเตอร์
  const FilterReviewerWidget({
    super.key,
    this.maximum = 10000,
    required this.onUpdate,
    this.initial,
  });

  @override
  _FilterReviewerWidgetState createState() => _FilterReviewerWidgetState();
}

class _FilterReviewerWidgetState extends State<FilterReviewerWidget> {
  // ประกาศ initial _reviewer
  int? _reviewer;
  TextEditingController reviewerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ประกาศ initial จาก parameter ของ FilterreviewerWidget
    final initial = widget.initial;
    if (initial != null) {
      _reviewer = initial;
      reviewerController.text =
          _reviewer == null /*|| _reviewer == 0*/ ? '-' : '$_reviewer';
    }
  }

  @override
  void dispose() {
    super.dispose();
    reviewerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ปุ่มลบ
        GestureDetector(
          onTap: () {
            _reviewer ??= 0;

            if (_reviewer == null) return;

            if ((_reviewer ?? 0) >= 1) {
              setState(() {
                _reviewer = (_reviewer ?? 0) - 1;
                if (_reviewer == null /*|| _reviewer == 0*/) {
                  reviewerController.clear();
                } else {
                  reviewerController.text = '$_reviewer';
                }
              });

              widget.onUpdate(_reviewer ?? 0);
            }
          },
          child: Assets.icons.icMinus.svg(
            width: 16.w,
            height: 16.h,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        BaseTextField(
          label: _reviewer == null ? '     -' : '',
          counterText: "",
          maxLength: 6,
          width: 70.w,
          textAlign: TextAlign.center,
          textInputType: TextInputType.number,
          controller: reviewerController,
          onFieldSubmitted: (val) {
            setState(() {
              _reviewer = int.parse(val);
            });

            widget.onUpdate(_reviewer ?? 0);
          },
        ),

        SizedBox(
          width: 8.w,
        ),
        // ปุ่มเพิ่ม
        GestureDetector(
          onTap: () {
            _reviewer ??= 0;

            if (_reviewer == null) return;

            if ((_reviewer ?? 0) < widget.maximum) {
              setState(() {
                _reviewer = (_reviewer ?? 0) + 1;
                reviewerController.text = '$_reviewer';
              });

              widget.onUpdate(_reviewer ?? 0);
            }
          },
          child: Assets.icons.icAddCart.svg(
            width: 16.w,
            height: 16.h,
          ),
        ),
      ],
    );
  }
}
