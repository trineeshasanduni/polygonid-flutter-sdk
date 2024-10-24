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

class UpdateProfileEvent extends ProfileEvent {
   final String OwnerDid;
  final String OwnerEmail;
  final String FirstName;
  final String LastName;
  final String City;
  final String Country;
  final String AddressLine1;
  final String AddressLine2;
  final String PostalCode;
  final String PhoneNumber;
  final String CountryCode;
  final String Description;
  final String Street;
  final String State;
  final String AccountType;
  final String CompanyName;
  final String CompanyRegno;
  
  final String OwnerAddress;
  
  const UpdateProfileEvent({
    required this.OwnerDid,
    required this.OwnerEmail,
    required this.FirstName,
    required this.LastName,
    required this.City,
    required this.Country,
    required this.AddressLine1,
    required this.AddressLine2,
    required this.PostalCode,
    required this.PhoneNumber,
    required this.CountryCode,
    required this.Description,
    required this.Street,
    required this.State,
    required this.AccountType,
    required this.CompanyName,
    required this.CompanyRegno,
    // required this.ProfileImage,
    required this.OwnerAddress,
   
  });
}

  class GetUpdateProfileEvent extends ProfileEvent {
  final String Did;
  final String OwnerAddress;
  
  const GetUpdateProfileEvent({
    required this.Did,
    required this.OwnerAddress,
   
  });
}

