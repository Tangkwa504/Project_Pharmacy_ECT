import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

class BaseTextField extends StatefulWidget {
  // ... (ส่วนนี้เป็นการกำหนดพารามิเตอร์ต่าง ๆ ของ TextField)
  final Object? fieldKey;

  final bool isAutoFocus;
  final bool isAutocorrect;
  final bool isEnabled;
  final bool isObscureText;
  final bool isExpands;
  final bool isReadOnly;
  final String? placeholder;

  final String? label;
  final int? maxLength;
  final int? maxLines;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextEditingController? controller;
  final String? initialValue;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;

  final String? errorOrWarningText;
  final ValueChanged<String>? onChange;
  final FocusNode? focusNode;
  final String? restorationId;
  final BoxConstraints? suffixIconSize;

  final void Function(String?)? onSave;
  final void Function()? onEditingComplete;

  final EdgeInsetsGeometry? contentPadding;
  final bool? isDense;
  final TextAlign textAlign;

  final bool isPhoneFormatter;
  final Color? borderColor;
  final double? borderWidth;
  final bool isShowLabelField;
  final Color? readOnlyColor;
  final Color? textColor;

  final double? width;
  final String? counterText;

  const BaseTextField({
    super.key,
    this.fieldKey,
    this.placeholder,
    this.isAutoFocus = false,
    this.isAutocorrect = false,
    this.isEnabled = true,
    this.isObscureText = false,
    this.isExpands = false,
    this.isReadOnly = false,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.inputFormatters,
    this.autovalidateMode,
    this.controller,
    this.textInputType,
    this.onTap,
    this.maxLength,
    this.onFieldSubmitted,
    this.errorOrWarningText,
    this.onChange,
    this.focusNode,
    this.restorationId,
    this.onSave,
    this.onEditingComplete,
    this.maxLines,
    this.isPhoneFormatter = false,
    this.suffixIconSize,
    this.contentPadding,
    this.isDense,
    this.borderColor,
    this.borderWidth,
    this.isShowLabelField = false,
    this.textAlign = TextAlign.start,
    this.readOnlyColor,
    this.textColor,
    this.width,
    this.counterText,
  });

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField>
    // ... (ส่วนนี้เป็นการสร้าง State สำหรับจัดการสถานะของ TextField)
    implements
        BaseFormField<String> {
  late FocusNode fieldFocusNode;
  TextEditingController? _controller;
  bool isValidated = false;
  String? _errorText;
  bool isShowLabel = true;
  String? _value;

  @override
  // ... (ส่วนนี้เป็นการเริ่มต้นการทำงานของ State)
  void initState() {
    super.initState();
    final controller = widget.controller;
    final initialValue = widget.initialValue;

    if (controller != null) {
      _controller = controller;
    } else {
      _controller = TextEditingController();
      if (initialValue != null) {
        _controller?.text = initialValue;
      }
    }

    if (initialValue != null) {
      _setValue(initialValue);
    } else {
      final text = _controller?.text;
      if (text != null) {
        _setValue(text);
      }
    }

    final focusNode = widget.focusNode;
    if (focusNode != null) {
      fieldFocusNode = focusNode;
    } else {
      fieldFocusNode = FocusNode();
    }

    fieldFocusNode.addListener(_handleFocusChanged);
    fieldFocusNode.addListener(_ensureVisible);
    _controller?.addListener(_handleControllerChanged);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setShowLabel();
      widget.controller?.addListener(_setShowLabel);
    });
  }

  void _setShowLabel() {
    final controller = widget.controller;
    if (controller != null && controller.text.isNotEmpty) {
      setState(() {
        isShowLabel = false;
      });
    }
  }

  @override
  // ... (ส่วนนี้เป็นการสร้าง UI ของ TextField)
  Widget build(BuildContext context) {
    final fieldKey = widget.fieldKey;
    if (fieldKey != null) {
      BaseForm.of(context)?.register(fieldKey, this);
    }

    final textLabel = widget.label;
    bool isShowLabelField = widget.isShowLabelField;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: isShowLabelField ? 24 : 0).h,
              child: FocusScope(
                onFocusChange: (value) {
                  setState(() {
                    isShowLabel = !value;
                  });
                },
                child: SizedBox(
                  width: widget.width,
                  child: TextFormField(
                    style: TextStyle(
                      color: widget.textColor ?? AppColor.themeTextColor,
                    ),
                    textAlign: widget.textAlign,
                    restorationId: widget.restorationId,
                    readOnly: widget.isReadOnly,
                    onFieldSubmitted: widget.onFieldSubmitted,
                    maxLength: widget.maxLength,
                    onTap: widget.onTap,
                    keyboardType: widget.textInputType,
                    expands: widget.isExpands,
                    controller: widget.controller,
                    autovalidateMode: widget.autovalidateMode,
                    enabled: widget.isEnabled,
                    validator: widget.validator,
                    initialValue: widget.initialValue,
                    maxLines: widget.isObscureText ? 1 : widget.maxLines,
                    onSaved: widget.onSave,
                    onEditingComplete: widget.onEditingComplete,
                    decoration: InputDecoration(
                      counterText: widget.counterText,
                      hintText: widget.placeholder,
                      suffixIconConstraints: widget.suffixIconSize,
                      fillColor: widget.isReadOnly
                          ? widget.readOnlyColor ?? AppColor.themeGrayLight
                          : Colors.white,
                      filled: true,
                      prefixIcon: widget.prefixIcon,
                      suffixIcon: widget.suffixIcon,
                      enabled: widget.isEnabled,
                      contentPadding:
                          widget.contentPadding ?? const EdgeInsets.all(8).w,
                      isDense: widget.isDense,
                      label:
                          textLabel != null && isShowLabel && !isShowLabelField
                              ? Text(
                                  textLabel,
                                  style: AppStyle.txtBody,
                                )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0).w,
                        borderSide: BorderSide(
                          color:
                              widget.borderColor ?? AppColor.themePrimaryColor,
                          width: (widget.borderWidth ?? 1.0).w,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8).w,
                        borderSide: BorderSide(
                          color:
                              widget.borderColor ?? AppColor.themePrimaryColor,
                          width: (widget.borderWidth ?? 1.0).w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8).w,
                        borderSide: BorderSide(
                          color:
                              widget.borderColor ?? AppColor.themePrimaryColor,
                          width: (widget.borderWidth ?? 1.0).w,
                        ),
                      ),
                    ),
                    onChanged: didChange,
                    obscureText: widget.isObscureText,
                    autofocus: widget.isAutoFocus,
                    autocorrect: widget.isAutocorrect,
                  ),
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
        if (textLabel != null && isShowLabelField)
          Positioned(
            top: 4,
            child: Text(
              textLabel,
              style: AppStyle.txtCaption,
            ),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    // ... (ส่วนนี้เป็นการสร้าง Widget สำหรับแสดงข้อผิดพลาดหากมี)
    final text = errorText;
    Widget? footer;
    if (hasError && text != null) {
      footer = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          text,
          style: AppStyle.txtError,
        ),
      );
    }

    return footer ?? const SizedBox.shrink();
  }

  void _setValue(String value) {
    // ... (ส่วนนี้เป็นการกำหนดค่าให้กับ TextField)
    _value = value;
    final text = _controller?.text;
    if (text != null && text != value) {
      _controller?.text = value;
    }
    if (mounted) setState(() {});
  }

  void _handleFocusChanged() {
    // ... (ส่วนนี้เป็นการจัดการเมื่อมีการเปลี่ยนแปลงใน Focus)
    if (mounted) setState(() {});
  }

  void didChange(String value) {
    // ... (ส่วนนี้เป็นการจัดการเมื่อมีการเปลี่ยนแปลงใน TextField)
    _setValue(value);

    if (widget.fieldKey != null) {
      BaseForm.of(context)?.fieldDidChange();
    }

    if (widget.onChange != null) {
      widget.onChange!(value);
    }

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  void _validate() {
    // ... (ส่วนนี้เป็นการตรวจสอบความถูกต้องของข้อมูล)
    final validator = widget.validator;
    if (validator != null) {
      _errorText = validator(value);
    }
    isValidated = true;
  }

  void _handleControllerChanged() {
    // ... (ส่วนนี้เป็นการจัดการเมื่อมีการเปลี่ยนแปลงใน Controller ของ TextField)
    final text = _controller?.text;
    if (text != null && text != value) {
      didChange(text);
    }
  }

  @override
  void clear() {
    _setValue('');
  }

  @override
  void focus() {
    fieldFocusNode.requestFocus();
  }

  @override
  bool get isValid {
    final validator = widget.validator;
    return validator == null || validator(value) == null;
  }

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
    final errorText = widget.errorOrWarningText;
    return _errorText != null ||
        (errorText != null && errorText.isNotEmpty == true);
  }

  String? get errorText => _errorText ?? widget.errorOrWarningText;

  @override
  String? get value => _value;

  @override
  void dispose() {
    // ... (ส่วนนี้เป็นการจัดการเมื่อ State ถูก dispose)
    fieldFocusNode.removeListener(_handleFocusChanged);
    fieldFocusNode.removeListener(_ensureVisible);
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(BaseTextField oldWidget) {
    // ... (ส่วนนี้เป็นการจัดการเมื่อ Widget ถูกอัปเดต)
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      final oldWidgetController = oldWidget.controller;
      final widgetController = widget.controller;

      if (oldWidgetController != null && widgetController == null) {
        _controller =
            TextEditingController.fromValue(oldWidgetController.value);
      }
      if (widgetController != null) {
        _controller?.text = widgetController.text;
        if (oldWidgetController == null) {
          _controller = null;
        }
      }
    }
  }

  Future<void> _ensureVisible() async {
    // ... (ส่วนนี้เป็นการแนะนำให้ TextField อยู่ในกรอบของหน้าจอ)
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 100), () async {
        if (!fieldFocusNode.hasFocus) {
          return;
        }

        final object = context.findRenderObject();
        final viewport = RenderAbstractViewport.of(object);
        final scrollableState = Scrollable.of(context);

        final position = scrollableState.position;
        double alignment;
        if (object == null) return;
        if (position.pixels > viewport.getOffsetToReveal(object, 0.0).offset) {
          // Move down to the top of the viewport
          alignment = 0.0;
        } else if (position.pixels <
            viewport.getOffsetToReveal(object, 1.0).offset) {
          // Move up to the bottom of the viewport
          alignment = 1.0;
        } else {
          // No scrolling is necessary to reveal the child
          return;
        }
        await position.ensureVisible(object, alignment: alignment);
      });
    });
  }
}
