import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/activityEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/getEmailEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/updateProfileEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/validateOTPEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/verifyEmailEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/verifyTelEntity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ActivityEntity>> activityLogs({
    required String did,
    
  });
  Future<Either<Failure, verifyEmailEntity>> VerifyEmail({
    required String Did,
    required String UserEmail,
    
  });

   Future<Either<Failure, verifyEmailEntity>> updateVerifyEmail({
    required String Did,
    required String UserEmail,
    required String Token,
    
  });

  Future<Either<Failure, GetEmailEntity>> getEmailVerify({
    required String Did,
  
    
  });

  Future<Either<Failure, VerifyTelEntity>> VerifyTel({
    required String DID,
    required String Mobile,
    
  });

   Future<Either<Failure, ValidateOTPEntity>> validateOTP({
    required String DID,
    required String OTP,
    
  });

  Future<Either<Failure, UpdateProfileEntity>> updateUserProfile({
     required String OwnerDid,
    required String OwnerEmail,
    required String FirstName,
    required String LastName,
    required String Country,
    required String PhoneNumber,
    required String AccountType,
    required String CompanyName,
    required String CompanyRegno,
    required String City,
    required String PostalCode,
    required String CountryCode,
    required String Description,
    required String Street,
    required String State,
    required String AddressLine1,
    required String AddressLine2,
    // required int ProfileImage,
    required String OwnerAddress,
    
  });

  Future<Either<Failure, UpdateProfileEntity>> getUpdateProfile({
    required String Did,
    required String OwnerAddress,
  
    
  });
  }
  
  