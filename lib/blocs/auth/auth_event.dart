import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PhoneNumberChanged extends AuthEvent {
  final String phoneNumber;

  PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class CountryCodeChanged extends AuthEvent {
  final String countryCode;

  CountryCodeChanged(this.countryCode);

  @override
  List<Object?> get props => [countryCode];
}

class OtpChanged extends AuthEvent {
  final String otp;

  OtpChanged(this.otp);

  @override
  List<Object?> get props => [otp];
}

class AuthSubmitted extends AuthEvent {}

class RequestOTP extends AuthEvent {
  final String phoneNumber;

  RequestOTP(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class OtpSent extends AuthEvent {
  final String verificationId;

  OtpSent(this.verificationId);

  @override
  List<Object?> get props => [verificationId];
}

class WrongPhone extends AuthEvent {
  final bool isWrongPhone;

  WrongPhone(this.isWrongPhone);

  @override
  List<Object?> get props => [isWrongPhone];
}

class WrongOTP extends AuthEvent {
  final bool isFailure;

  WrongOTP(this.isFailure);

  @override
  List<Object?> get props => [isFailure];
}

class SetVerificatioID extends AuthEvent {
  final String verificationId;

  SetVerificatioID(this.verificationId);

  @override
  List<Object?> get props => [verificationId];
}
class SetOtpSending extends AuthEvent {
  final bool otpSending;

  SetOtpSending(this.otpSending);

  @override
  List<Object?> get props => [otpSending];
}

class SetIsSuccess extends AuthEvent {
  final bool isSuccess;

  SetIsSuccess(this.isSuccess);

  @override
  List<Object?> get props => [isSuccess];
}
class VerifyOTP extends AuthEvent {
  final String verificationId;
  final String otp;

  VerifyOTP(this.verificationId, this.otp);

  @override
  List<Object?> get props => [verificationId, otp];
}

class AuthReset extends AuthEvent {
  AuthReset();
}
