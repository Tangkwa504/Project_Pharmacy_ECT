import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/auth/auth_provider.dart';
import 'package:pharmacy_online/feature/authentication/model/request/forgot_password_request.dart';

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  //รับ dependency จาก Provider ต่างๆ
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  //สร้างและคืนค่า instance ของ ForgotPasswordUsecase
  return ForgotPasswordUsecase(
    ref,
    firebaseAuth,
  );
});

class ForgotPasswordUsecase extends UseCase<ForgotPasswordRequest, bool> {
  final FirebaseAuthProvider firebaseAuth;

  ForgotPasswordUsecase(
    Ref ref,
    this.firebaseAuth,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ForgotPasswordRequest request,
  ) async {
    try {
        // รียกใช้ฟังชั่นใน FirebaseAuthProvider เพื่อส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมลที่ระบุใน request
      final result = await firebaseAuth.sendPasswordResetEmail(request.email);

      return result;
    } catch (e) {
      return false;
    }
  }
}
