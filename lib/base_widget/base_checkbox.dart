import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

// BaseCheckBox Widget ใน Flutter
class BaseCheckBox extends StatefulWidget {
  final Object? fieldKey; // กำหนด fieldKey เพื่อใช้กับ BaseForm
  final bool? initialValue; // กำหนดค่าเริ่มต้นของ CheckBox
  final FocusNode? focusNode; // กำหนด focusNode เพื่อให้สามารถควบคุมการ focus

  final bool isEnabled; // กำหนดให้ CheckBox ใช้งานหรือไม่
  final ValueChanged<bool>?
      onChanged; // กำหนดฟังก์ชันที่จะถูกเรียกเมื่อมีการเปลี่ยนแปลงใน CheckBox
  final Widget? label; // กำหนด Label ที่จะแสดงด้วย CheckBox
  final bool? error; // กำหนด Error ที่จะแสดงหรือไม่แสดง
  final FormFieldValidator<String>?
      validator; // กำหนด Validator สำหรับ validate ค่าของ CheckBox

  // Constructor ของ Widget
  const BaseCheckBox({
    Key? key,
    this.fieldKey,
    this.initialValue,
    this.onChanged,
    this.isEnabled = true,
    this.label,
    this.validator,
    this.focusNode,
    this.error,
  }) : super(key: key);

  @override
  _BaseCheckBoxState createState() => _BaseCheckBoxState();
}

class _BaseCheckBoxState extends State<BaseCheckBox>
    implements BaseFormField<bool> {
  bool _value = true;
  String? _errorText;
  late FocusNode fieldFocusNode;

  var isValidated = false;

  // ฟังก์ชันนี้จะถูกเรียกเมื่อ State ถูกสร้าง
  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? false;

    final focusNode = widget.focusNode;
    if (focusNode != null) {
      fieldFocusNode = focusNode;
    } else {
      fieldFocusNode = FocusNode();
    }

    _setValue(widget.initialValue ?? false);
  }

  // ฟังก์ชันนี้จะถูกเรียกเมื่อ Widget ถูก build
  @override
  Widget build(BuildContext context) {
    // ลงทะเบียน BaseForm
    final fieldKey = widget.fieldKey;
    if (fieldKey != null) {
      BaseForm.of(context)?.register(fieldKey, this);
    }

    final textContent = widget.label;

    // สร้าง Widget ของ CheckBox
    final checkBoxContainer = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Widget ของ CheckBox ที่ให้ผู้ใช้เลือก
            _CheckBox(
              isEnabled: widget.isEnabled,
              value: _value,
              onChanged: onChanged,
            ),
            if (textContent != null) ...[
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: textContent,
              ),
            ],
          ],
        ),
        // แสดงข้อผิดพลาด (ถ้ามี)
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 28).w,
            child: Text(
              _errorText!,
              style: AppStyle.txtError,
            ),
          ),
      ],
    );
    return checkBoxContainer;
  }

  // ฟังก์ชันที่เรียกเมื่อมีการเปลี่ยนแปลงใน CheckBox
  void onChanged(bool? value) {
    _setValue(value ?? false);
    widget.onChanged?.call(_value);
    if (widget.fieldKey != null) {
      BaseForm.of(context)?.fieldDidChange();
    }
  }

  // Getter ที่ให้ค่า validateValue เป็น String?
  String? get validateValue => _value == false ? '' : _value.toString();

  // ฟังก์ชัน clear ที่กำหนดค่า _value เป็น false
  @override
  void clear() {
    _setValue(false);
  }

  // Getter ที่กำหนดค่า _value และ validate Text
  void _setValue(bool value) {
    _value = value;
    if (_value) {
      _errorText = null;
    } else {
      validate();
    }
    setState(() {});
  }

  // ฟังก์ชัน focus ที่ให้ focus ไปที่ fieldFocusNode
  @override
  void focus() {
    fieldFocusNode.requestFocus();
  }

  // ฟังก์ชันที่ให้ค่า validateValue ผ่าน validator
  void _validate() {
    final validator = widget.validator;
    if (validator != null) {
      _errorText = validator(validateValue);
    }
    isValidated = true;
  }

  // Getter ที่คืนค่าว่า CheckBox ถูกต้องหรือไม่
  @override
  bool get isValid {
    final validator = widget.validator;
    return validator == null || validator(validateValue) == null;
  }

  bool get hasError {
    return _errorText != null || errorText != null;
  }

  @override
  bool validate() {
    setState(() {
      _validate();
    });
    return !hasError;
  }

  String? get errorText => _errorText;

  @override
  bool? get value => _value;
}

// Widget ของ CheckBox
class _CheckBox extends StatelessWidget {
  final bool isEnabled;
  final bool value;
  final Function(bool) onChanged;

  const _CheckBox({
    Key? key,
    required this.isEnabled,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  // สร้าง Widget ของ CheckBox
  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: BoxConstraints.loose(
        const Size(
          21,
          21,
        ),
      ),
      padding: EdgeInsets.zero,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: isEnabled
          ? () {
              onChanged(!value);
            }
          : null,
      icon: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: AppColor.themePrimaryColor,
            width: 1,
          ),
          color: AppColor.themeWhiteColor,
        ),
        child: value
            ? Center(
                child: Assets.icons.icCheck.svg(
                  color: isEnabled
                      ? AppColor.themePrimaryColor
                      : AppColor.themeWhiteColor,
                ),
              )
            : null,
      ),
    );
  }
}
