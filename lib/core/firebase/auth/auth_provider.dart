// Import the firebase_core and cloud_firestore plugin
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider สำหรับให้บริการ FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuthProvider>((ref) {
  return FirebaseAuthProvider(
    fireAuth: FirebaseAuth.instance,
  );
});

/// this is a wrapper class for FirebaseFirebaseDatabase.
class FirebaseAuthProvider {
  final FirebaseAuth fireAuth;

  FirebaseAuthProvider({
    required this.fireAuth,
  });

  // สร้างบัญชีผู้ใช้ใหม่ด้วยอีเมลและรหัสผ่าน
  Future<UserCredential> createEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await fireAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential;
  }

  // เข้าสู่ระบบด้วยอีเมลและรหัสผ่าน
  Future<UserCredential> singInEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await fireAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential;
  }

  // ส่งอีเมลล์เพื่อรีเซ็ตรหัสผ่าน
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await fireAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // เปลี่ยนรหัสผ่าน
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final Completer<bool> completer = Completer<bool>();
      final user = fireAuth.currentUser;
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred).then((_) async {
        await user.updatePassword(newPassword).then((_) {
          completer.complete(true);
        }).catchError((error) {
          completer.complete(false);
        });
      }).catchError((err) {
        completer.complete(false);
      });

      return completer.future;
    } catch (e) {
      return false;
    }
  }

  // ออกจากระบบ
  Future<bool> signOut() async {
    try {
      await fireAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
