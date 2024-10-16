import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/profile/data/dataSources/profile_dataSource.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/activityModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/getEmailModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/updateProfileModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/validateOTPModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/verifyEmailModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/verifyTelModel.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/activityEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/getEmailEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/updateProfileEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/validateOTPEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/verifyEmailEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/verifyTelEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/repositories/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepository {
  final ProfileRemoteDatasource profileRemoteDatasource;

  ProfileRepoImpl({required this.profileRemoteDatasource});

  @override
Future<Either<Failure, ActivityEntity>> activityLogs({
  required String did,
}) async {
  try {
    // Fetching the activity logs from remote datasource
    ActivityModel activityModel = await profileRemoteDatasource.activityLogs(
      did: did,
    );

    // Check if groupedLogs is not null
    if (activityModel.groupedLogs != null) {
      // Map all the grouped logs
      List<GroupedLogs> groupedLogsList = activityModel.groupedLogs!.map((group) {
        return GroupedLogs(
          logs: group.logs!.map((log) {
            // Mapping each log
            return Logs(
              did: log.did!,
              id: log.id!,
              name: log.name!,
              data: log.data!,
              level: log.level!,
              traceId: log.traceId!,
              timestamp: Timestamp(
                seconds: log.timestamp!.seconds!,
                nanos: log.timestamp!.nanos!,
              ),
              humanReadableTimestamp: log.humanReadableTimestamp!,
            );
          }).toList(), // Convert the logs to a list
        );
      }).toList(); // Convert the grouped logs to a list

      // Return the mapped ActivityEntity
      return right(ActivityEntity(groupedLogs: groupedLogsList));
    } else {
      return left(Failure('No grouped logs found'));
    }
  } catch (error) {
    // Return failure if there's an exception
    return left(Failure('Failed to retrieve logs: $error'));
  }
}

  @override
Future<Either<Failure, verifyEmailEntity>> VerifyEmail({
  required String Did,
  required String UserEmail,
}) async {
  try {
    // Fetching the activity logs from remote datasource
    VerifyEmailModel verifyEmailModel = await profileRemoteDatasource.verifyEmail(
      Did: Did,
      UserEmail: UserEmail,
    );

    // Check if groupedLogs is not null
     return right(verifyEmailEntity());
  } catch (error) {
    // Return failure if there's an exception
    return left(Failure('Failed to retrieve logs: $error'));
  }
}

@override
Future<Either<Failure, verifyEmailEntity>> updateVerifyEmail({
  required String Did,
  required String UserEmail,
  required String Token,  
}) async {
  try {
    // Fetching the activity logs from remote datasource
    VerifyEmailModel verifyEmailModel = await profileRemoteDatasource.updateVerifyEmail(
      Did: Did,
      UserEmail: UserEmail,
      Token: Token,
    );

    // Check if groupedLogs is not null
     return right(verifyEmailEntity(
       
     ));
  } catch (error) {
    // Return failure if there's an exception
    return left(Failure('Failed to retrieve logs: $error'));
  }
}

@override
Future<Either<Failure, GetEmailEntity>> getEmailVerify({
  required String Did,
   
}) async {
  try {
    // Fetching the activity logs from remote datasource
    GetEmailModel verifyEmailModel = await profileRemoteDatasource.getEmailVerify(
      did: Did,
    
    );
      print('verify email response: ${verifyEmailModel.isVerified}');

    // Check if groupedLogs is not null
     return right(GetEmailEntity(
      
       
        userEmail: verifyEmailModel.userEmail,
        isVerified: verifyEmailModel.isVerified,
       
    

       
     ));
  } catch (error) {
    // Return failure if there's an exception
    return left(Failure('Failed to retrieve logs: $error'));
  }
}


///////////////////////////////verify phone number///////////////////
///
@override
Future<Either<Failure, VerifyTelEntity>> VerifyTel({
  required String DID,
  required String Mobile,
}) async {
  try {
    // Fetching the activity logs from remote datasource
    VerifyTelModel verifyEmailModel = await profileRemoteDatasource.verifyTel(
      DID: DID,
      Mobile: Mobile
      
    );

    // Check if groupedLogs is not null
     return right(VerifyTelEntity());
  } catch (error) {
    // Return failure if there's an exception
    return left(Failure('Failed to retrieve logs: $error'));
  }
}

@override
Future<Either<Failure, ValidateOTPEntity>> validateOTP({
  required String DID,
  required String OTP,
}) async {
  try {
    // Fetching the activity logs from remote datasource
    ValidateOTPModel validateOTPModel = await profileRemoteDatasource.validateOTP(
      DID: DID,
      OTP: OTP
      
    );

    // Check if groupedLogs is not null
     return right(ValidateOTPEntity(
      validate: validateOTPModel.validate
     ));
  } catch (error) {
    // Return failure if there's an exception
    return left(Failure('Failed to retrieve logs: $error'));
  }
}



//////////////////////////update profile//////////////////////////
///
@override
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
}) async {
  try {
    // Fetching the activity logs from remote datasource
    UpdateProfileModel updateProfileModel = await profileRemoteDatasource.updateUserProfile(
      OwnerDid: OwnerDid,
      OwnerEmail : OwnerEmail,
      FirstName :FirstName,
      LastName :LastName,
      Country :Country,
      PhoneNumber :PhoneNumber,
      AccountType :AccountType,
      CompanyName :CompanyName,
      CompanyRegno :CompanyRegno,
      City :City,
      PostalCode :PostalCode,
      CountryCode :CountryCode,
      Description :Description,
      Street :Street,
      State :State,
      AddressLine1 :AddressLine1,
      AddressLine2 :AddressLine2
      

      
    );

    // Check if groupedLogs is not null
     return right(UpdateProfileEntity(
      ownerDid: updateProfileModel.ownerDid,
      firstName: updateProfileModel.firstName


      
     )
     );
  } catch (error) {
    // Return failure if there's an exception
    return left(Failure('Failed to retrieve logs: $error'));
  }
}

  
}