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

// class UpdateProfileUsecase
//     implements UseCase<UpdateProfileEntity, UpdateProfileParam> {
//   final ProfileRepository profileRepository;
//   const UpdateProfileUsecase(this.profileRepository);

//   @override
//   Future<Either<Failure, UpdateProfileEntity>> call(
//       UpdateProfileParam params) async {
//     print('registering12: ${params.OwnerEmail}');
//     return await profileRepository.updateUserProfile(
//       OwnerDid: params.OwnerDid,
//       OwnerEmail: params.OwnerEmail,
//       FirstName: params.FirstName,
//       LastName: params.LastName,

      
      
      
//     );
//   }
// }

// class UpdateProfileParam {
//   final String OwnerDid;
//   final String OwnerEmail;
//   final String FirstName;
//   final String LastName;
  

//   UpdateProfileParam({
//     required this.OwnerDid,
//     required this.OwnerEmail,
//     required this.FirstName,
//     required this.LastName
//   });



  
// }