import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:polygonid_flutter_sdk/profile/data/dataSources/profile_dataSource.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/activityModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/getEmailModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/updateProfileModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/validateOTPModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/verifyEmailModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/verifyTelModel.dart';

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final http.Client client;

  ProfileRemoteDatasourceImpl({required this.client});

  static const BASE_URL = 'https://test.becx.io/api/v1';

  @override
  Future<ActivityModel> activityLogs({
    required String did,
  }) async {
    print('fetching file name');
    try {
      final Did = jsonDecode(did);
      print('did activity: $Did');
      final response = await client.get(Uri.parse('$BASE_URL/logs?did=$Did'));

      print('file name status1: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('fetch file name status code: ${response.statusCode}');
        final activityLogsList = jsonDecode(response.body);
        final activityLogs = activityLogsList["grouped_logs"];
        print('grouped_logs: $activityLogs');

        if (activityLogsList.isNotEmpty) {
          final activityLogsModel = ActivityModel.fromJson(activityLogs);
          print("activityLogs response: ${activityLogsModel.toJson()}");
          return activityLogsModel;
        } else {
          throw Exception('No data found in the response');
        }
      } else {
        throw Exception('Failed to load activity: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activity: $e');
      throw Exception('Failed to fetch activity');
    }
  }

  @override
  Future<VerifyEmailModel> verifyEmail({
    required String Did,
    required String UserEmail,
  }) async {
    print('verify email');
    try {
      Map<String, dynamic> data = {"Did": Did, "UserEmail": UserEmail};
      // Define the URI for the use-space API endpoint
      final uri = Uri.parse('$BASE_URL/save-email-verify');

      // Make the POST request with the proper headers and body
      final response = await client.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('data verify email: $data');

      print('verify email status code: ${response.statusCode}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = VerifyEmailModel.fromJson(jsonResponse);
      // final fileResponse = VerifyEmailModel(

      // );

      if (response.statusCode == 200) {
        return responseProof;
      } else {
        print('Failed to verify email');
        throw Exception('Failed to verify email');
      }
    } catch (error) {
      print('Error during verify email: $error');
      throw Exception('Failed to verify email');
    }
  }

  @override
  Future<VerifyEmailModel> updateVerifyEmail({
    required String Did,
    required String UserEmail,
    required String Token,
  }) async {
    print('verify email');
    try {
      Map<String, dynamic> data = {
        "Did": Did,
        "UserEmail": UserEmail,
        "Token": Token
      };
      // Define the URI for the use-space API endpoint
      final uri = Uri.parse('$BASE_URL/update-email-verify');

      // Make the POST request with the proper headers and body
      final response = await client.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('data verify email: $data');

      print('verify email status code: ${response.statusCode}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = VerifyEmailModel.fromJson(jsonResponse);
      // final fileResponse = VerifyEmailModel(

      // );

      if (response.statusCode == 200) {
        return responseProof;
      } else {
        print('Failed to verify email');
        throw Exception('Failed to verify email');
      }
    } catch (error) {
      print('Error during verify email: $error');
      throw Exception('Failed to verify email');
    }
  }

  @override
  Future<GetEmailModel> getEmailVerify({
    required String did,
  }) async {
    try {
      final response = await client
          .get(Uri.parse('$BASE_URL/get-email-verify?OwnerDid=$did'));

      print('get verify status1: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('fetch get verify status code: ${response.statusCode}');
        final isVerified = jsonDecode(response.body);

        print('isVerified: $isVerified');

        final verifiedModel = GetEmailModel.fromJson(isVerified);
        print("verified response: ${verifiedModel.toJson()}");
        return verifiedModel;
      } else {
        throw Exception('Failed to load verified: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching verified: $e');
      throw Exception('Failed to fetch verified');
    }
  }

  /////////////////////////phone no verify///////////////////////
  ///
  @override
  Future<VerifyTelModel> verifyTel({
    required String DID,
    required String Mobile,
  }) async {
    print('verify tel');
    try {
      Map<String, dynamic> data = {"DID": DID, "Mobile": Mobile};
      // Define the URI for the use-space API endpoint
      final uri = Uri.parse('$BASE_URL/otp');

      // Make the POST request with the proper headers and body
      final response = await client.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('data verify tel: $data');

      print('verify tel status code: ${response.statusCode}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = VerifyTelModel.fromJson(jsonResponse);
      // final fileResponse = VerifyEmailModel(

      // );

      if (response.statusCode == 200) {
        return responseProof;
      } else {
        print('Failed to verify tel');
        throw Exception('Failed to verify tel');
      }
    } catch (error) {
      print('Error during verify tel: $error');
      throw Exception('Failed to verify tel');
    }
  }

  @override
  Future<ValidateOTPModel> validateOTP({
    required String DID,
    required String OTP,
  }) async {
    print('validate OTP');
    try {
      Map<String, dynamic> data = {"DID": DID, "OTP": OTP};
      // Define the URI for the use-space API endpoint
      final uri = Uri.parse('$BASE_URL/otp-validate');

      // Make the POST request with the proper headers and body
      final response = await client.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('data validate OTP: $data');

      print('validate OTP status code: ${response.statusCode}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = ValidateOTPModel.fromJson(jsonResponse);
      // final fileResponse = VerifyEmailModel(

      // );

      if (response.statusCode == 200) {
        return responseProof;
      } else {
        print('Failed to validate OTP');
        throw Exception('Failed to validate OTP');
      }
    } catch (error) {
      print('Error during validate OTP: $error');
      throw Exception('Failed to validate OTP');
    }
  }

  ///////////////////////////////////user profile update//////////////////////////////
  ///
  @override
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
    // required int ProfileImage,
    required String OwnerAddress,
  }) async {
    print('update profile');
    try {
      Map<String, dynamic> data = {
        "OwnerDid": OwnerDid,
        "OwnerEmail,": OwnerEmail,
        "FirstName": FirstName,
        "LastName": LastName,
        "Country": Country,
        "PhoneNumber": PhoneNumber,
        "CompanyName": CompanyName,
        "AccountType": AccountType,
        "CompanyRegno": CompanyRegno,
        "City": City,
        "PostalCode": PostalCode,
        "CountryCode": CountryCode,
        "Description": Description,
        "Street": Street,
        "State": State,
        "AddressLine1": AddressLine1,
        "AddressLine2": AddressLine2,
        // "ProfileImage": ProfileImage,
        "OwnerAddress": OwnerAddress
      };
      // Define the URI for the use-space API endpoint
      final uri = Uri.parse('$BASE_URL/update-user-profile');

      // Make the POST request with the proper headers and body
      final response = await client.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('data update profile: ${response.body}');

      print('update profile status code: ${response.statusCode}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = UpdateProfileModel.fromJson(jsonResponse);
      print('jsonResponse: $responseProof');
      // final fileResponse = VerifyEmailModel(

      // );

      if (response.statusCode == 200) {
        return responseProof;
      } else {
        print('Failed to update profile');
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      print('Error during update profile: $error');
      throw Exception('Failed to update profile');
    }
  }


  @override
  Future<UpdateProfileModel> getUpdateProfile({
    required String did,
    required String OwnerAddress,
  }) async {
    try {
      final response = await client
          .get(Uri.parse('$BASE_URL/get-user-profile?OwnerDid=$did&OwnerAddress=$OwnerAddress'));

      print('get profile status1: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('fetch get profile status code: ${response.statusCode}');
        final getProfile = jsonDecode(response.body);

        print('isVerified: $getProfile');

        final profileModel = UpdateProfileModel.fromJson(getProfile);
        print("verified response: ${profileModel.toJson()}");
        return profileModel;
      } else {
        throw Exception('Failed to load verified: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching verified: $e');
      throw Exception('Failed to fetch verified');
    }
  }
}
