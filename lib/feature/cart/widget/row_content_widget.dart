import 'package:flutter/material.dart';
import 'package:pharmacy_online/core/app_style.dart';

class RowContentWidget extends StatelessWidget {
  final String header;
  final String label;
  final bool isBold;

  const RowContentWidget({
    super.key,
    required this.header,
    required this.label,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          header,
          style: AppStyle.txtBody2.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          label,
          style: AppStyle.txtBody2.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
