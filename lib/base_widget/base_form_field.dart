import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// baseFormDataProvider คือ Provider ที่ให้ค่าเป็น BaseFormData เพื่อให้ Widget ต่าง ๆ สามารถเข้าถึงข้อมูลฟอร์มได้
final baseFormDataProvider = Provider(
  ((ref) {
    return BaseFormData();
  }),
);

// BaseFormField คือ Interface ที่ต้องการให้ Widget ของ FormField ต้อง Implement โดยต้องมีเมทอด focus, clear, validate, get value, get isValid
abstract class BaseFormField<T> {
  void focus();
  void clear();
  bool validate();

  T? get value;
  bool get isValid;
}

// BaseFormData เป็นคลาสที่เก็บข้อมูลฟอร์มทั้งหมด
class BaseFormData {
  final Map<Object, Object> _formData;

  // เมทอดที่ใช้ในการกำหนดค่าของ key ในข้อมูลฟอร์ม (_formData)
  BaseFormData({Map<Object, Object>? initialData})
      : _formData = initialData ?? {};

  void setValue(Object? value, {required Object key}) {
    if (value == null) {
      _formData.remove(key);
    } else {
      _formData[key] = value;
    }
  }

  // เมทอดที่ใช้ในการดึงค่าของ key จากข้อมูลฟอร์ม (_formData)
  T? getValue<T>(Object key) {
    final _obj = _formData[key];
    if (_obj == null) {
      return null;
    }
    assert(
      _obj is T,
      'Value of key [$key] has type [${_obj.runtimeType}] but expected to be [${T.toString()}]',
    );
    return _obj as T?;
  }

  // เมทอดที่ใช้ในการลบ key ออกจากข้อมูลฟอร์ม (_formData)
  void removeKey(Object key) {
    _formData.remove(key);
  }

  // เมทอดที่ใช้ในการตรวจสอบว่า key นี้มีอยู่ในข้อมูลฟอร์มหรือไม่
  bool hasKey(Object key) {
    return _formData.containsKey(key);
  }

  // เมทอดที่ใช้ในการคัดลอกข้อมูลจาก BaseFormData อื่น และรวมรวมเข้ากับข้อมูลปัจจุบัน
  BaseFormData copyAndMerge(BaseFormData data) {
    return BaseFormData(
      initialData: <Object, Object>{}
        ..addAll(_formData)
        ..addAll(data._formData),
    );
  }

  // เมทอดที่ใช้ในการเปรียบเทียบข้อมูลระหว่าง BaseFormData นี้กับ BaseFormData อื่น
  @override
  bool operator ==(Object other) {
    if (other is BaseFormData) {
      return mapEquals(_formData, other._formData);
    } else {
      return false;
    }
  }

  // เมทอดที่ใช้ในการคำนวณ hashCode ของ BaseFormData
  int get length => _formData.length;

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}

// BaseForm เป็น StatefulWidget ที่ถูกใช้เพื่อรวบรวม BaseFormField และมีหน้าที่จัดการกับการ validate, focus, clear ข้อมูลฟอร์ม
class BaseForm extends StatefulWidget {
  @override
  final Key key;
  final Widget child;
  final void Function(BaseFormData)? onChanged;

  const BaseForm({required this.key, required this.child, this.onChanged})
      : super(key: key);

  static BaseFormState? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<BaseFormScope>();
    return scope?._formState;
  }

  @override
  BaseFormState createState() => BaseFormState();
}

class BaseFormState extends State<BaseForm> {
  final fields = <Object, BaseFormField>{};
  final fieldKeys = <Object>{};
  bool isFirstTime = true;
  bool _isBulkEditField = false;

  @override
  void dispose() {
    fields.clear();
    fieldKeys.clear();
    super.dispose();
  }

  bool save({
    required void Function(BaseFormData) onSave,
    bool focusErrorField = true,
  }) {
    if (isFirstTime) {
      setState(() {
        isFirstTime = false;
      });
    }

    if (validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      onSave(formData);
      return true;
    } else if (focusErrorField == true) {
      for (var key in fieldKeys) {
        final fieldKey = fields[key];
        if (fieldKey == null) continue;
        if (!fieldKey.isValid) {
          fieldKey.focus();
          return false;
        }
      }
    }
    return false;
  }

  bool validate() {
    var isValid = true;
    fields.forEach((key, state) {
      final _isValid = state.validate();
      isValid = isValid && _isValid;
    });

    return isValid;
  }

  void clearFields(List<Object> clearKeys) {
    for (var key in clearKeys) {
      final fieldKey = fields[key];
      if (fieldKey != null) {
        fieldKey.clear();
        fieldKey.validate();
      }
    }
  }

  void clearAllFields() {
    for (var element in fields.entries) {
      element.value.clear();
      element.value.validate();
    }
  }

  void focusField(Object field) {
    fields[field]?.focus();
  }

  void register(Object fieldKey, BaseFormField field) {
    fields[fieldKey] = field;
    if (!fieldKeys.contains(fieldKey)) {
      fieldKeys.add(fieldKey);
    }
  }

  void unregister(Object fieldKey) {
    fields.remove(fieldKey);
    fieldKeys.remove(fieldKey);
  }

  bool get hasError {
    for (var key in fieldKeys) {
      final fieldKey = fields[key];
      if (fieldKey == null) continue;
      if (!fieldKey.isValid) {
        return true;
      }
    }
    return false;
  }

  // ... ส่วนนี้เป็นการจัดการ focus, clear, validate ข้อมูลฟอร์ม

  BaseFormData? _lastFormData;
  void fieldDidChange() {
    if (_isBulkEditField) {
      return;
    }

    final onChanged = widget.onChanged;

    if (onChanged != null) {
      if (_lastFormData != formData) {
        onChanged(formData);
      }

      _lastFormData = formData;
    }
    if (!isFirstTime) {
      validate();
    }
  }

  void onBulkEditField(FutureOr<void> Function() runner) async {
    _isBulkEditField = true;
    await runner.call();
    _isBulkEditField = false;

    fieldDidChange();
  }

  void clearIsFirstTime() {
    isFirstTime = true;
  }

  // ... ส่วนนี้เป็นการจัดการการเปลี่ยนแปลงข้อมูลฟอร์ม

  BaseFormData get formData {
    final result = BaseFormData();
    fields.forEach((key, state) {
      result.setValue(state.value, key: key);
    });
    return result;
  }

  // ... ส่วนนี้เป็นการดึงข้อมูลจาก fields และสร้าง BaseFormData

  @override
  Widget build(BuildContext context) {
    return BaseFormScope(
      formState: this,
      child: widget.child,
    );
  }
}

class BaseFormScope extends InheritedWidget {
  const BaseFormScope({
    Key? key,
    required Widget child,
    required BaseFormState formState,
    int? generation,
  })  : _formState = formState,
        _generation = generation,
        super(key: key, child: child);

  final int? _generation;
  final BaseFormState _formState;

  BaseFormState get formState => _formState;

  @override
  bool updateShouldNotify(BaseFormScope oldWidget) {
    return _generation != oldWidget._generation;
  }
}
