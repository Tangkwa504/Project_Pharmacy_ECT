import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

class BaseSwitchButton extends StatefulWidget {
  final List<SwitchButtonItem> listItem;
  final String label;
  final FormFieldValidator<String?>? validator;
  final ValueChanged<SwitchButtonItem>? onChange;
  final ValueChanged<bool>? onChangeBool;
  final List<SwitchButtonItem>? initialValue;
  final bool? error;
  final Object? fieldKey;
  final FocusNode? focusNode;
  final bool isMultiSelected;
  final EdgeInsets? contentPadding;
  final double? minWidth;
  final double? width;
  final Alignment align;
  final bool isSwitchButton;
//ประกาศและรับค่าตัวแปร isSwitchButton ซึ่งใช้เพื่อกำหนดว่า SwitchButton ถูกใช้งานหรือไม่

  const BaseSwitchButton({
    super.key,
    required this.listItem,
    required this.label,
    this.validator,
    this.onChangeBool,
    this.onChange,
    this.initialValue,
    this.error,
    this.fieldKey,
    this.focusNode,
    this.isMultiSelected = false,
    this.contentPadding,
    this.minWidth,
    this.width,
    this.align = Alignment.center,
    this.isSwitchButton = false,
  });

  @override
  _BaseSwitchButtonState createState() => _BaseSwitchButtonState();
}

class _BaseSwitchButtonState extends State<BaseSwitchButton>
    implements BaseFormField<List<SwitchButtonItem>> {
  List<SwitchButtonItem>? _value;
  List<bool> isSelected = [];
  late FocusNode fieldFocusNode;
  var isValidated = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final initialValue = widget.initialValue;
    final focusNode = widget.focusNode;

    if (focusNode != null) {
      fieldFocusNode = focusNode;
    } else {
      fieldFocusNode = FocusNode();
    }

    if (initialValue != null) {
      isSelected = widget.listItem.map((val) {
        return initialValue.any((item) => item.id == val.id);
      }).toList();
      _setValue(initialValue);
    } else {
      isSelected = List.generate(
        widget.listItem.length,
        (i) => widget.listItem[i].isSelected,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fieldKey = widget.fieldKey;
    if (fieldKey != null) {
      BaseForm.of(context)?.register(fieldKey, this);
    }

    final _listItem = widget.listItem;
    final textContent = widget.label;
    final width = widget.minWidth ?? widget.width;
    final isSwitchButton = widget.isSwitchButton;
    //isSwitchButton เพื่อเก็บค่าตัวแปร widget.isSwitchButton ไว้ในตัวแปร isSwitchButton ของคลาส

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (textContent.isNotEmpty) ...[
          Text(
            textContent,
            style: AppStyle.txtBody2,
          ),
          SizedBox(
            height: 4.0.h,
          ),
        ],
        StatefulBuilder(
          builder: (context, setState) {
            return Wrap(
              runSpacing: 5.0.w,
              spacing: 5.0.w,
              children: _listItem.map(
                (val) {
                  final index = _listItem.indexOf(val);
                  final _isSelected = isSelected[index];

                  return GestureDetector(
                    onTap: () {
                      if (isSelected.isEmpty) return;

                      if (widget.isMultiSelected) {
                        setState(() {
                          isSelected[index] = !_isSelected;
                        });
                      } else {
                        setState(
                          () {
                            isSelected = _listItem.map(
                              (item) {
                                final _index = _listItem.indexOf(item);

                                if (isSwitchButton) {
                                  return _index == index ? true : false;
                                }

                                return _index == index ? !_isSelected : false;
                              },
                            ).toList();
                          },
                        );
                      }

                      if (widget.onChangeBool != null) {
                        widget.onChangeBool!(isSelected[index]);
                      } else {
                        if (widget.onChange != null) {
                          widget.onChange!(val);
                        } else {
                          didChange(
                            val,
                            isSwitchButton
                                ? isSelected[index]
                                : !isSelected[index],
                          );
                        }
                      }
                    },
                    child: Container(
                      width: width,
                      alignment: widget.align,
                      padding:
                          widget.contentPadding ?? const EdgeInsets.all(8).r,
                      decoration: BoxDecoration(
                        color: _isSelected
                            ? AppColor.themePrimaryColor
                            : AppColor.themeWhiteColor,
                        border: Border.all(
                          color: AppColor.themePrimaryColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8).r,
                      ),
                      child: Text(
                        val.content,
                        textAlign: TextAlign.center,
                        maxLines: 2, // Set a maximum number of lines
                        overflow: TextOverflow.ellipsis, // Enable text wrapping
                        style: AppStyle.txtBody.copyWith(
                          color: _isSelected
                              ? AppColor.themeWhiteColor
                              : AppColor.themeGrayLight,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
        if (_errorText != null) ...[
          SizedBox(
            height: 4.0.h,
          ),
          Text(
            _errorText!,
            style: AppStyle.txtError,
          ),
        ]
      ],
    );
  }

  void didChange(SwitchButtonItem? value, bool? isSelected) {
    if (widget.isMultiSelected) {
      List<SwitchButtonItem>? val = _value == null ? [] : List.from(_value!);

      final hasValue = val.any((val) => val.id == value?.id);

      if (_value != null && hasValue) {
        val.removeWhere((item) => item.id == value?.id);
      } else {
        val.add(value!);
      }

      if (val.isEmpty) {
        _setValue(null);
      } else {
        _setValue(val);
      }
    } else {
      if (value == null || !isSelected!) {
        _setValue(null);
      } else {
        _setValue([value]);
      }
    }

    if (widget.fieldKey != null) {
      BaseForm.of(context)?.fieldDidChange();
    }
  }

  @override
  void clear() {
    _setValue(null);
  }

  @override
  void focus() {
    fieldFocusNode.requestFocus();
  }

  @override
  bool get isValid {
    final validator = widget.validator;
    return validator == null || validator(validateValue) == null;
  }

  void _validate() {
    final validator = widget.validator;
    if (validator != null) {
      _errorText = validator(validateValue);
    }
    isValidated = true;
  }

  String? get errorText => _errorText;

  String? get validateValue =>
      _value == null || _value!.isEmpty ? '' : _value.toString();

  @override
  bool validate() {
    if (mounted) {
      setState(() {
        _validate();
      });
    }
    return !hasError;
  }

  bool get hasError {
    return _errorText != null;
  }

  void _setValue(List<SwitchButtonItem>? value) {
    _value = value;
    setState(() {});
  }

  @override
  List<SwitchButtonItem>? get value => _value;
}

class SwitchButtonItem<T> {
  final int id;
  final String value;
  final bool isSelected;
  final String content;

  const SwitchButtonItem({
    required this.id,
    required this.value,
    required this.content,
    this.isSelected = false,
  });
}
