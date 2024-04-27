// ไลบรารีสำหรับตรวจสอบความถูกต้องของอีเมล
import 'package:pharmacy_online/utils/util/email_validator.dart';

// enum ที่ระบุสาเหตุของความล้มเหลวในการตรวจสอบ
enum ValidateFailResult {
  empty, // ค่าที่ใช้เมื่อค่าว่าง
  isNotEmpty, // ค่าที่ใช้เมื่อค่าไม่ถูกต้อง
  invalidPasswordNotMatch, // ค่าที่ใช้เมื่อรหัสผ่านไม่ตรงกัน
  invalidPasswordIsTheSame, // ค่าที่ใช้เมื่อรหัสผ่านใหม่เหมือนกับรหัสผ่านเก่า
  invalidEmailHasAlready, // ค่าที่ใช้เมื่ออีเมล์มีอยู่แล้ว
}

// typedef สำหรับฟังก์ชันที่รับ String? และคืนค่า ValidateFailResult?
typedef Validator = ValidateFailResult? Function(String?);
// typedef สำหรับฟังก์ชันที่รับ String? และคืนค่า String?
typedef ValidatorString = String? Function(String?);

// คลาสที่รวบรวมฟังก์ชันการตรวจสอบต่างๆ
class Validators {
  static ValidatorString combine(List<ValidatorString> validators) {
    return (String? str) {
      for (final validator in validators) {
        final result = validator(str);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }

  static ValidatorString withMessage(String message, Validator validator) {
    return (String? str) {
      final result = validator(str);
      if (result != null) {
        return message;
      }
      return null;
    };
  }

//ตรวจสอบว่าอีเมลถูกต้องหรือไม่
  static ValidateFailResult? isValidEmail(String? value) {
    final bool isValid = EmailValidator.validate(value!);
    if (!isValid) {
      return ValidateFailResult.isNotEmpty;
    }
    return null;
  }

  //ตรวจสอบว่าข้อความว่างเปล่าหรือไม่
  static ValidateFailResult? isTextEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return ValidateFailResult.empty;
    }
    return null;
  }

// ตรวจสอบว่าค่าว่างเปล่าหรือไม่ (คล้ายกับ isTextEmpty())
  static ValidateFailResult? isEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return ValidateFailResult.empty;
    }
    return null;
  }

//ตรวจสอบว่ามีการกรอกข้อมูลประเภทบัญชีหรือไม่
  static String? isNotSelectedAccountType(int? value, String message) {
    if (value == null) {
      return message;
    }
    return null;
  }

// isNotAcceptedTermsAndConditions(): ตรวจสอบว่ายอมรับข้อกำหนดและเงื่อนไขหรือไม่
  static String? isNotAcceptedTermsAndConditions(bool? value, String message) {
    if (value == false || value == null) {
      return message;
    }
    return null;
  }

// isValidPhoneNumberMinLength(): ตรวจสอบว่าหมายเลขโทรศัพท์มีความยาวอย่างน้อย 9 หลักหรือไม่
  static ValidateFailResult? isValidPhoneNumberLength(String? value) {
    if (value!.length < 9) {
      return ValidateFailResult.isNotEmpty;
    }
    return null;
  }

  // isValidZipCodeLength(): รหัสไปรษณีย์
  static ValidateFailResult? isValidZipCodeLength(String? value) {
    if (value!.length < 5) {
      return ValidateFailResult.isNotEmpty;
    }
    return null;
  }

// isValidPhoneNumberMinLength(): ตรวจสอบว่าหมายเลขโทรศัพท์มีความยาวอย่างน้อย 9หลักหรือไม่
  // static ValidateFailResult? isValidPhoneNumber(String? value) {
  //   // if (value == null || value.isEmpty) {
  //   //   return ValidateFailResult.isNotEmpty;
  //   // }

  //   if (value!.length < 9) {
  //     return ValidateFailResult.isNotEmpty;
  //   }

  //   RegExp re = RegExp(r'^[0-9]+$');
  //   final bool isValid = re.hasMatch(value);
  //   if (!isValid) {
  //     return ValidateFailResult.isNotEmpty;
  //   }
  //   return null;
  // }

// isValidPhoneNumberStartsWith(): ตรวจสอบว่าหมายเลขโทรศัพท์ขึ้นต้นด้วย '0' หรือไม่
  static ValidateFailResult? isValidPhoneNumberStartsWith(String? value) {
    if (!value!.startsWith('0')) {
      return ValidateFailResult.isNotEmpty;
    }
    return null;
  }

// isPasswordMatch(): ตรวจสอบว่ารหัสผ่านตรงกันหรือไม่
  static ValidateFailResult? isPasswordMatch(String? value1, String? value2) {
    return value1 == value2 ? null : ValidateFailResult.invalidPasswordNotMatch;
  }

// isNewPasswordSameAsOldPassword(): ตรวจสอบว่ารหัสผ่านใหม่เหมือนกับรหัสผ่านเก่าหรือไม่
  static ValidateFailResult? isNewPasswordSameAsOldPassword(
    String value1,
    String value2,
  ) {
    return value1 == value2
        ? ValidateFailResult.invalidPasswordIsTheSame
        : null;
  }

// isEamilHasAlready(): ตรวจสอบว่าอีเมล์มีอยู่แล้วหรือไม่
  static ValidateFailResult? isEamilHasAlready(
    bool hasEmailAlready,
  ) {
    return hasEmailAlready ? ValidateFailResult.invalidEmailHasAlready : null;
  }

// isValidPasswordMinLength(): ตรวจสอบว่ารหัสผ่านมีความยาวอย่างน้อย 6 ตัวอักษรหรือไม่
  static ValidateFailResult? isValidPasswordMinLength(String? value) {
    if (value!.length < 6) {
      return ValidateFailResult.isNotEmpty;
    }
    return null;
  }

// isValidUsername(): ตรวจสอบว่าชื่อผู้ใช้ถูกต้องตามรูปแบบที่กำหนดหรือไม่
  static ValidateFailResult? isValidUsername(String? value) {
    // อนุญาตให้ใช้เฉพาะตัวอักษร (a-z)(ก-ฮ) .- เท่านั้น
    RegExp re = RegExp(r"[^\u0E00-\u0E7Fa-zA-Z' \.\-]+");
    final bool isValid = re.hasMatch(value!);
    if (isValid) {
      return ValidateFailResult.isNotEmpty;
    }
    return null;
  }

// isValidPassword(): ตรวจสอบว่ารหัสผ่านมีรูปแบบที่ถูกต้องหรือไม่ (ต้องมีตัวอักษรเล็ก ใหญ่ ตัวเลข และความยาวอย่างน้อย 8 ตัวอักษร)
  static ValidateFailResult? isValidPassword(String? value) {
    RegExp re = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})");
    final bool isValid = re.hasMatch(value!);
    if (!isValid) {
      return ValidateFailResult.isNotEmpty;
    }
    return null;
  }

  static ValidateFailResult? isValidVerifyCodeMinLength(String? value) {
    if (value!.length < 6) {
      return ValidateFailResult.isNotEmpty;
    }
    return null;
  }
}
