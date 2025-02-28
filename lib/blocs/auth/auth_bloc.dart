import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../firebase/otp/otp_request.dart';
import '../../firebase/otp/verify_otp.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    
    on<PhoneNumberChanged>((event, emit) {
      emit(state.copyWith(phoneNumber: event.phoneNumber));
    });

    
    on<CountryCodeChanged>((event, emit) {
      emit(state.copyWith(countryCode: event.countryCode));
    });

    
    on<OtpChanged>((event, emit) {
      emit(state.copyWith(otp: event.otp,isSuccess:false),);
    });

    
    on<WrongPhone>((event, emit) {
      emit(state.copyWith(isWrongPhone: event.isWrongPhone));
    });
    on<WrongOTP>((event, emit) {
      emit(state.copyWith(
          isFailure: event.isFailure, isSuccess: !event.isFailure));
    });

    on<SetIsSuccess>((event, emit) {
      emit(state.copyWith(isSuccess: event.isSuccess));
    });

    on<SetVerificatioID>((event, emit) {
      emit(state.copyWith(verificationId: event.verificationId));
    });

    on<SetOtpSending>((event, emit) {
      emit(state.copyWith(otpSending: event.otpSending));
    });
    on<RequestOTP>((event, emit) async {
      emit(state.copyWith(
        
        otpSending: true,
        isFailure: false,
        isSuccess: false,
      ));

      print('Requesting');

      try {
        
        requestOTP(
          event.phoneNumber,
          (verificationId) {
            
            add(OtpSent(verificationId));
          },
          (isFailure) async {
            
            print(isFailure ? 'Wrong phone number' : 'OTP sent successfully');
            add(SetOtpSending(false));
            add(WrongPhone(isFailure));
          },
        );
      } catch (e) {
        print("Unexpected error: $e");
      }

    });

    
    on<OtpSent>((event, emit) {
      emit(state.copyWith(
        verificationId: event.verificationId,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        isWrongPhone: false,
      ));
    });

    
    on<VerifyOTP>((event, emit) async {
      emit(state.copyWith(
          isSubmitting: true, isFailure: false, isSuccess: false));

      final otpVerification = OTPVerification();
      try {
        await otpVerification.verifyOTP(event.verificationId, event.otp,
            (failed) {
          add(WrongOTP(failed));
        });
        emit(state.copyWith(isSubmitting: false));
      } catch (_) {
        emit(state.copyWith(isSubmitting: false));
      }
    });

    
    on<AuthSubmitted>((event, emit) async {
      emit(state.copyWith(
          isSubmitting: true, isFailure: false, isSuccess: false));

      final otpVerification = OTPVerification();
      try {
        
        await otpVerification.verifyOTP(state.verificationId, state.otp,
            (failed) {
          print('otp ${failed}');
          add(WrongOTP(failed));
        });

        
        emit(state.copyWith(isSubmitting: false));
      } catch (_) {
        
        emit(state.copyWith(isSubmitting: false, isFailure: true));
      }
    });
    
    on<AuthReset>((event, emit) {
      
      emit(const AuthState());
    });
  }
}
