import 'package:polygonid_flutter_sdk/profile/data/models/activityModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/getEmailModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/updateProfileModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/validateOTPModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/verifyEmailModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/verifyTelModel.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/verifyEmailEntity.dart';

abstract class ProfileRemoteDatasource {
  Future<ActivityModel> activityLogs({
    required String did,
  });

  Future<VerifyEmailModel> verifyEmail({
   required String Did,
    required String UserEmail,
  });

   Future<VerifyEmailModel> updateVerifyEmail({
   required String Did,
    required String UserEmail,
    required String Token,
  });

   Future<GetEmailModel> getEmailVerify({
   required String did,
    
  });

  Future<VerifyTelModel> verifyTel({
   required String DID,
    required String Mobile,
  });
   Future<ValidateOTPModel> validateOTP({
    required String DID,
    required String OTP,
  }) ;

 Future<UpdateProfileModel> updateUserProfile({
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
  });
  
  
  }

