import 'package:firebase_auth/firebase_auth.dart';

void requestOTP(String phoneNumber, Function(String) codeSentCallback, Function(bool) isFailure) async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      
      
      print('No implementation needed');
    },
    verificationFailed: (FirebaseAuthException e) {
      
      print('Hey Failed');
      print('Verification failed: ${e.message}');
      isFailure(true);
    },
    codeSent: (String verificationId, int? resendToken) {
      
      print('Code sent to $phoneNumber');
      codeSentCallback(verificationId);
      isFailure(false);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      
      print('Auto retrieval timeout');
    },
  );
}
