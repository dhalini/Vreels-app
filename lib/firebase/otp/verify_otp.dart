import 'package:firebase_auth/firebase_auth.dart';

class OTPVerification {
  Future<void> verifyOTP(String verificationId, String smsCode, Function(bool) isFailed) async {
    try {
      
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      
      await FirebaseAuth.instance.signInWithCredential(credential);
      print('Phone number verified and user signed in!');
      isFailed(false);
    } catch (e) {
      print('Error verifying OTP: $e');
      isFailed(true);
    }
  }
}
