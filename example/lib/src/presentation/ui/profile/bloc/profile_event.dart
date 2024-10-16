part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ActivityLogsEvent extends ProfileEvent {
  final String did;

  const ActivityLogsEvent({
    required this.did,
  });


}

class VerifyEmailEvent extends ProfileEvent {
  final String Did;
  final String UserEmail;

  const VerifyEmailEvent({
    required this.Did,
    required this.UserEmail,
  });
}

class VerifyTelEvent extends ProfileEvent {
  final String DID;
  final String Mobile;

  const VerifyTelEvent({
    required this.DID,
    required this.Mobile,
  });
}

class UpdateVerifyEmailEvent extends ProfileEvent {
  final String Did;
  final String UserEmail;
  final String Token;

  const UpdateVerifyEmailEvent({
    required this.Did,
    required this.UserEmail,
    required this.Token,
  });
}

class GetVerifyEmailEvent extends ProfileEvent {
  final String Did;
  
  const GetVerifyEmailEvent({
    required this.Did,
   
  });
}

class ValidateOTPEvent extends ProfileEvent {
  final String Did;
  final String OTP;
  
  const ValidateOTPEvent({
    required this.Did,
    required this.OTP
   
  });
}
