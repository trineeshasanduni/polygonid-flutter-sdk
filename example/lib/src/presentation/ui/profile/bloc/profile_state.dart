part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class LogsUpdating extends ProfileState {}

final class LogsUpdated extends ProfileState {
  final ActivityEntity logs;

  const LogsUpdated(this.logs);
}

final class LogsUpdateFailed extends ProfileState {
  final String message;

  const LogsUpdateFailed(this.message);
}
final class Sending extends ProfileState {}

final class Verifying extends ProfileState {}

final class Updating extends ProfileState {}

final class OtpVerifiying extends ProfileState {}

final class EmailSentFailed extends ProfileState {
  final String message;

  const EmailSentFailed(this.message);
}

final class UpdateFailed extends ProfileState {
  final String message;

  const UpdateFailed(this.message);
}

final class EmailSend extends ProfileState {
  final verifyEmailEntity email;

  const EmailSend(this.email);
}

final class EmailVerified extends ProfileState {
  final verifyEmailEntity email;

  const EmailVerified(this.email);
}

final class EmailUpdated extends ProfileState {
  final GetEmailEntity email;

  const EmailUpdated(this.email);
}

final class EmailGettingFailed extends ProfileState {
  final String message;

  const EmailGettingFailed(this.message);
}

final class VerifyFailed extends ProfileState {
  final String message;

  const VerifyFailed(this.message);
}
 final class ValidateFailed extends ProfileState {
  final String message;

  const ValidateFailed(this.message);
}

final class OTPSend extends ProfileState {
  final VerifyTelEntity otp;

  const OTPSend(this.otp);
}


final class Validate extends ProfileState {
  final ValidateOTPEntity otp;

  const Validate(this.otp);
}




