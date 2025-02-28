import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final String countryCode;
  final String phoneNumber;
  final String otp;
  final String verificationId;
  final String language;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool otpSending;
  final bool isWrongPhone;


  const AuthState({
    this.countryCode = '+1',
    this.phoneNumber = '',
    this.otp = '',
    this.verificationId = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.isWrongPhone=false,
    this.otpSending=false,
    this.language = 'English (US)',
  });

  AuthState copyWith({
    String? countryCode,
    String? phoneNumber,
    String? otp,
    String? verificationId,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    bool? isWrongPhone,
    bool? otpSending,
    String? language,
  }) {
    return AuthState(
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      verificationId: verificationId ?? this.verificationId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      otpSending: otpSending ?? this.otpSending,
      isWrongPhone: isWrongPhone ?? this.isWrongPhone,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        countryCode,
        phoneNumber,
        otp,
        verificationId,
        isSubmitting,
        isSuccess,
        isWrongPhone,
        isFailure,
        otpSending,
        language,
      ];
}
