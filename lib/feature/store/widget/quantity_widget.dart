import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class QuantityWidget extends StatefulWidget {
  final int maximum;
  final Function(int quantity) onUpdate;
  final double? itemSized;
  final double? textSized;
  final int? initial;

  const QuantityWidget({
    super.key,
    this.maximum = 0,
    this.itemSized,
    this.textSized,
    required this.onUpdate,
    this.initial,
  });

  @override
  _QuantityWidgetState createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends State<QuantityWidget> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _quantity = initial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (_quantity > 1) {
              setState(() {
                _quantity -= 1;
              });

              widget.onUpdate(_quantity);
            }
          },
          child: Assets.icons.icMinus.svg(
            width: widget.itemSized,
            height: widget.itemSized,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          '$_quantity',
          style: AppStyle.txtBody.copyWith(
            fontSize: widget.textSized,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        GestureDetector(
          onTap: () {
            if (_quantity < widget.maximum) {
              setState(() {
                _quantity += 1;
              });

              widget.onUpdate(_quantity);
            }
          },
          child: Assets.icons.icAddCart.svg(
            width: widget.itemSized,
            height: widget.itemSized,
          ),
        ),
      ],
    );
  }
}
