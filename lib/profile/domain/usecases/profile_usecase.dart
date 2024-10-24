import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/common/usecase/usecase.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/activityEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/getEmailEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/updateProfileEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/validateOTPEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/verifyEmailEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/verifyTelEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/repositories/profile_repo.dart';

class ProfileUsecase implements UseCase<ActivityEntity, ProfileParams> {
  final ProfileRepository profileRepository;
  const ProfileUsecase(this.profileRepository);

  @override
  Future<Either<Failure, ActivityEntity>> call(ProfileParams params) async {
    print('registering12: ${params.did}');
    return await profileRepository.activityLogs(
      did: params.did,
    );
  }
}

class VerifyEmailUsecase
    implements UseCase<verifyEmailEntity, VerifyEmailParams> {
  final ProfileRepository profileRepository;
  const VerifyEmailUsecase(this.profileRepository);

  @override
  Future<Either<Failure, verifyEmailEntity>> call(
      VerifyEmailParams params) async {
    print('registering12: ${params.Did}');
    return await profileRepository.VerifyEmail(
      Did: params.Did,
      UserEmail: params.UserEmail,
    );
  }
}

class UpdateVerifyEmailUsecase
    implements UseCase<verifyEmailEntity, UpdateVerifyEmailParams> {
  final ProfileRepository profileRepository;
  const UpdateVerifyEmailUsecase(this.profileRepository);

  @override
  Future<Either<Failure, verifyEmailEntity>> call(
      UpdateVerifyEmailParams params) async {
    print('registering12: ${params.Did}');
    return await profileRepository.updateVerifyEmail(
      Did: params.Did,
      UserEmail: params.UserEmail,
      Token: params.Token,

    );
  }
}

class GetVerifyEmailUsecase
    implements UseCase<GetEmailEntity, GetVerifyEmailParams> {
  final ProfileRepository profileRepository;
  const GetVerifyEmailUsecase(this.profileRepository);

  @override
  Future<Either<Failure, GetEmailEntity>> call(
      GetVerifyEmailParams params) async {
    print('registering12: ${params.Did}');
    return await profileRepository.getEmailVerify(
      Did: params.Did,
      

    );
  }
}

class ValidateOTPUsecase
    implements UseCase<ValidateOTPEntity, ValidateOTPParams> {
  final ProfileRepository profileRepository;
  const ValidateOTPUsecase(this.profileRepository);

  @override
  Future<Either<Failure, ValidateOTPEntity>> call(
      ValidateOTPParams params) async {
    print('registering12: ${params.Did}');
    return await profileRepository.validateOTP(
      DID: params.Did,
      OTP: params.OTP
      

    );
  }
}

class VerifyEmailParams {
  final String Did;
  final String UserEmail;

  VerifyEmailParams({
    required this.Did,
    required this.UserEmail,
  });
}

class ValidateOTPParams {
  final String Did;
  final String OTP;

  ValidateOTPParams({
    required this.Did,
    required this.OTP,
  });
}

class GetVerifyEmailParams {
  final String Did;


  GetVerifyEmailParams({
    required this.Did,
  
  });
}
class UpdateVerifyEmailParams {
  final String Did;
  final String UserEmail;
  final String Token;

  UpdateVerifyEmailParams({
    required this.Did,
    required this.UserEmail,
    required this.Token,
  });
}
class ProfileParams {
  final String did;

  ProfileParams({
    required this.did,
  });



  
}
//////////////////////////////////////////////
  ///
  class VerifyTelUsecase
    implements UseCase<VerifyTelEntity, VerifyTelParams> {
  final ProfileRepository profileRepository;
  const VerifyTelUsecase(this.profileRepository);

  @override
  Future<Either<Failure, VerifyTelEntity>> call(
      VerifyTelParams params) async {
    print('registering12: ${params.DID}');
    return await profileRepository.VerifyTel(
      DID: params.DID,
      Mobile: params.Mobile,
    );
  }
}

class VerifyTelParams {
  final String DID;
  final String Mobile;

  VerifyTelParams({
    required this.DID,
    required this.Mobile
  });



  
}


///////////////////////////////update user profile//////////////////

class UpdateProfileUsecase
    implements UseCase<UpdateProfileEntity, UpdateProfileParam> {
  final ProfileRepository profileRepository;
  const UpdateProfileUsecase(this.profileRepository);

  @override
  Future<Either<Failure, UpdateProfileEntity>> call(
      UpdateProfileParam params) async {
    print('registering12: ${params.OwnerEmail}');
    return await profileRepository.updateUserProfile(
      OwnerDid: params.OwnerDid,
      OwnerEmail: params.OwnerEmail,
      FirstName: params.FirstName,
      LastName: params.LastName,
      City: params.City,
      Country: params.Country,
      AddressLine1: params.AddressLine1,
      AddressLine2: params.AddressLine2,
      PostalCode: params.PostalCode,
      PhoneNumber:params.PhoneNumber,
      AccountType: params.AccountType,
      CompanyName: params.CompanyName,
      CompanyRegno: params.CompanyRegno,
      CountryCode: params.CountryCode,
      Description: params.Description,
      Street: params.Street,
      State: params.State,
      // ProfileImage: params.ProfileImage,
      OwnerAddress: params.OwnerAddress,

      
    );
  }
}

class GetUpdateProfileUsecase
    implements UseCase<UpdateProfileEntity, GetUpdateProfileParams> {
  final ProfileRepository profileRepository;
  const GetUpdateProfileUsecase(this.profileRepository);

  @override
  Future<Either<Failure, UpdateProfileEntity>> call(
      GetUpdateProfileParams params) async {
    print('registering12: ${params.Did}');
    return await profileRepository.getUpdateProfile(
      Did: params.Did,
      OwnerAddress: params.OwnerAddress,
      

    );
  }
}

class GetUpdateProfileParams {
  final String Did;
  final String OwnerAddress;


  GetUpdateProfileParams({
    required this.Did,
    required this.OwnerAddress,
  
  });
}

class UpdateProfileParam {
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
  final String CompanyRegno;
  final String CompanyName;
  // final int ProfileImage;
  final String OwnerAddress;

  

  

  UpdateProfileParam({
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