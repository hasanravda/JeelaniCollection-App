import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId,int? resendToken) onCodeSent,
    required Function(PhoneAuthCredential credential) onVerificationCompleted,
    required Function(FirebaseAuthException e) onVerificationFailed,
    required Function() onCodeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      timeout: const Duration(seconds: 60),
       verificationCompleted: onVerificationCompleted,
       verificationFailed: onVerificationFailed,
       codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (_) => onCodeAutoRetrievalTimeout(),
    );
  }


  Future<UserCredential> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode
    );
    return await _auth.signInWithCredential(credential);
  }
}
