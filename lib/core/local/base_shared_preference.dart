import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider สำหรับจัดการกับ SharedPreferences
final sharedPreferences =
    Provider<SharedPreferences>((_) => throw UnimplementedError());

// Enum ที่กำหนดคีย์ของ SharedPreferences
enum BaseSharePreferenceKey {
  isFirstTime,
  localeCode,
  email,
  password,
  isRemember,
  role,
  userId,
}

// Extension สำหรับแปลง BaseSharePreferenceKey เป็นคีย์ของ SharedPreferences
extension _BaseSharePreferenceKeyStr on BaseSharePreferenceKey {
  String get sharedPrefsKey {
    switch (this) {
      case BaseSharePreferenceKey.isFirstTime:
        return 'IS_FIRST_TIME';
      case BaseSharePreferenceKey.localeCode:
        return 'LOCALE_CODE';
      case BaseSharePreferenceKey.email:
        return 'EMAIL';
      case BaseSharePreferenceKey.password:
        return "PASSWORD";
      case BaseSharePreferenceKey.isRemember:
        return "IS_REMEMBER";
      case BaseSharePreferenceKey.role:
        return "ROLE";
      case BaseSharePreferenceKey.userId:
        return "USER_ID";
      default:
        assert(false);
    }

    return '';
  }
}

// Inject sharedPrefs provider to BaseSharedPreference
final baseSharePreferenceProvider = Provider<BaseSharedPreference>((ref) {
  final pref = ref.watch(sharedPreferences);

  return BaseSharedPreference(pref);
});

// Class สำหรับจัดการกับ SharedPreferences
class BaseSharedPreference {
  final SharedPreferences? _preferences;

  BaseSharedPreference(this._preferences);

  // ดึงค่า Boolean จาก SharedPreferences
  bool? getBool(BaseSharePreferenceKey sharedPreferenceKey) =>
      _preferences?.getBool(sharedPreferenceKey.sharedPrefsKey);

  // ดึงค่า Integer จาก SharedPreferences
  int? getInt(BaseSharePreferenceKey sharedPreferenceKey) =>
      _preferences?.getInt(sharedPreferenceKey.sharedPrefsKey);

  // ดึงค่า Double จาก SharedPreferences
  double? getDouble(BaseSharePreferenceKey sharedPreferenceKey) =>
      _preferences?.getDouble(sharedPreferenceKey.sharedPrefsKey);

  // ดึงค่า String จาก SharedPreferences
  String? getString(BaseSharePreferenceKey sharedPreferenceKey) =>
      _preferences?.getString(sharedPreferenceKey.sharedPrefsKey);

  // บันทึกค่า Boolean ลงใน SharedPreferences
  Future<bool>? setBool(
    BaseSharePreferenceKey sharedPreferenceKey,
    bool value,
  ) =>
      _preferences?.setBool(sharedPreferenceKey.sharedPrefsKey, value);

  // บันทึกค่า Integer ลงใน SharedPreferences
  Future<bool>? setInt(BaseSharePreferenceKey sharedPreferenceKey, int value) =>
      _preferences?.setInt(sharedPreferenceKey.sharedPrefsKey, value);

  // บันทึกค่า Double ลงใน SharedPreferences
  Future<bool>? setDouble(
    BaseSharePreferenceKey sharedPreferenceKey,
    double value,
  ) =>
      _preferences?.setDouble(sharedPreferenceKey.sharedPrefsKey, value);

  // บันทึกค่า String ลงใน SharedPreferences
  Future<bool>? setString(
    BaseSharePreferenceKey sharedPreferenceKey,
    String value,
  ) =>
      _preferences?.setString(sharedPreferenceKey.sharedPrefsKey, value);

  // ลบค่าจาก SharedPreferences
  Future<bool>? remove(BaseSharePreferenceKey sharedPreferenceKey) =>
      _preferences?.remove(sharedPreferenceKey.sharedPrefsKey);

  // ล้างข้อมูลทั้งหมดใน SharedPreferences
  Future<bool>? clear() => _preferences?.clear();
}
