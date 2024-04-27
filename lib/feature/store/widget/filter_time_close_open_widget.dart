import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';

class FilterTimeCloseOpenWidget extends StatefulWidget {
  final Function(String open) onUpdateOpen;
  final Function(String close) onUpdateClose;
  final String? initialOpen;
  final String? initialClose;

  const FilterTimeCloseOpenWidget({
    super.key,
    required this.onUpdateOpen,
    required this.onUpdateClose,
    this.initialOpen,
    this.initialClose,
  });

  @override
  _FilterTimeCloseOpenWidgetState createState() =>
      _FilterTimeCloseOpenWidgetState();
}

class _FilterTimeCloseOpenWidgetState extends State<FilterTimeCloseOpenWidget> {
  @override
  Widget build(BuildContext context) {
    TimeOfDay initialOpeningTimeParsed = TimeOfDay.now();
    TimeOfDay initialCloseingTimeParsed = TimeOfDay.now();
    final _initialOpen = widget.initialOpen;
    final _initialClose = widget.initialClose;

    if (_initialOpen != null && _initialOpen.isNotEmpty) {
      final initialOpen = _initialOpen.split(':');
      int initialOpenHour = int.parse(initialOpen[0]);
      int initialOpenMinute = int.parse(initialOpen[1]);
      initialOpeningTimeParsed =
          TimeOfDay(hour: initialOpenHour, minute: initialOpenMinute);
    }

    if (_initialClose != null && _initialClose.isNotEmpty) {
      final initialClose = _initialClose.split(':');
      int initialCloseHour = int.parse(initialClose[0]);
      int initialCloseMinute = int.parse(initialClose[1]);
      initialCloseingTimeParsed =
          TimeOfDay(hour: initialCloseHour, minute: initialCloseMinute);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: BaseTextField(
            placeholder: _initialOpen != null && _initialOpen.isNotEmpty
                ? _initialOpen
                : 'เวลาเปิด',
            isReadOnly: true,
            onTap: () async {
              final openingTime = await showTimePicker(
                context: context,
                initialTime: initialOpeningTimeParsed,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );

              if (openingTime != null) {
                widget.onUpdateOpen(
                    '${openingTime.hour.toString().padLeft(2, '0')}:${openingTime.minute.toString().padLeft(2, '0')}');
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: const Text(
            '-',
          ),
        ),
        Expanded(
          child: BaseTextField(
            placeholder: _initialClose != null && _initialClose.isNotEmpty
                ? _initialClose
                : 'เวลาปิด',
            isReadOnly: true,
            onTap: () async {
              final closingTime = await showTimePicker(
                context: context,
                initialTime: initialCloseingTimeParsed,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );

              if (closingTime != null) {
                widget.onUpdateClose(
                    '${closingTime.hour.toString().padLeft(2, '0')}:${closingTime.minute.toString().padLeft(2, '0')}');
              }
            },
          ),
        ),
      ],
    );
  }
}
