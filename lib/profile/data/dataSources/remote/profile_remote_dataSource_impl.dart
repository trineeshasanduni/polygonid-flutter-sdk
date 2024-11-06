import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:polygonid_flutter_sdk/profile/data/dataSources/profile_dataSource.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/activityModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/getEmailModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/profilePicModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/updateProfileModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/validateOTPModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/verifyEmailModel.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/verifyTelModel.dart';

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final http.Client client;

  ProfileRemoteDatasourceImpl({required this.client});

  static const BASE_URL = 'https://test.becx.io/api/v1';
    // static const BASE_URL = 'http://192.168.1.218:9000/api/v1';


  @override
  Future<ActivityModel> activityLogs({
    required String did,
  }) async {
    try {
      final Did = jsonDecode(did);
      final response = await client.get(Uri.parse('$BASE_URL/logs?did=$Did'));


      if (response.statusCode == 200) {
        final activityLogsList = jsonDecode(response.body);
        final activityLogs = activityLogsList["grouped_logs"];

        if (activityLogsList.isNotEmpty) {
          final activityLogsModel = ActivityModel.fromJson(activityLogs);
          return activityLogsModel;
        } else {
          throw Exception('No data found in the response');
        }
      } else {
        throw Exception('Failed to load activity: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch activity');
    }
  }

  @override
  Future<VerifyEmailModel> verifyEmail({
    required String Did,
    required String UserEmail,
  }) async {
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

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = VerifyEmailModel.fromJson(jsonResponse);
      // final fileResponse = VerifyEmailModel(

      // );

      if (response.statusCode == 200) {
        return responseProof;
      } else {
        throw Exception('Failed to verify email');
      }
    } catch (error) {
      throw Exception('Failed to verify email');
    }
  }

  @override
  Future<VerifyEmailModel> updateVerifyEmail({
    required String Did,
    required String UserEmail,
    required String Token,
  }) async {
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

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = VerifyEmailModel.fromJson(jsonResponse);
      // final fileResponse = VerifyEmailModel(

      // );

      if (response.statusCode == 200) {
        return responseProof;
      } else {
        throw Exception('Failed to verify email');
      }
    } catch (error) {
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


      if (response.statusCode == 200) {
        final isVerified = jsonDecode(response.body);


        final verifiedModel = GetEmailModel.fromJson(isVerified);
        return verifiedModel;
      } else {
        throw Exception('Failed to load verified: ${response.statusCode}');
      }
    } catch (e) {
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

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = VerifyTelModel.fromJson(jsonResponse);
      // final fileResponse = VerifyEmailModel(

      // );

      if (response.statusCode == 200) {
        return responseProof;
      } else {
        throw Exception('Failed to verify tel');
      }
    } catch (error) {
      throw Exception('Failed to verify tel');
    }
  }

  @override
  Future<ValidateOTPModel> validateOTP({
    required String DID,
    required String OTP,
  }) async {
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
      
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = ValidateOTPModel.fromJson(jsonResponse);
      // final fileResponse = VerifyEmailModel(

      // );

      if (response.statusCode == 200) {
        return responseProof;
      } else {
        throw Exception('Failed to validate OTP');
      }
    } catch (error) {
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

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = UpdateProfileModel.fromJson(jsonResponse);
      // final fileResponse = VerifyEmailModel(

      // );

      if (response.statusCode == 200) {
        return responseProof;
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      throw Exception('Failed to update profile');
    }
  }

  @override
  Future<UpdateProfileModel> getUpdateProfile({
    required String did,
    required String OwnerAddress,
  }) async {
    try {
      final response = await client.get(Uri.parse(
          '$BASE_URL/get-user-profile?OwnerDid=$did&OwnerAddress=$OwnerAddress'));


      if (response.statusCode == 200) {
        final getProfile = jsonDecode(response.body);


        final profileModel = UpdateProfileModel.fromJson(getProfile);
        return profileModel;
      } else {
        throw Exception('Failed to load verified: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch verified');
    }
  }

  @override
  Future<ProfilePicModel> uploadProfilePic({
    required File profile_image,
    required String ownerDid,
  }) async {
    try {
      final uri = Uri.parse('$BASE_URL/update-user-profile-image');

      // Prepare multipart request
      var request = http.MultipartRequest('PUT', uri)
        ..fields['ownerDid'] = ownerDid
        ..files.add(await http.MultipartFile.fromPath(
            'profile_image', profile_image.path));

    

      // Send the request and wait for response
      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString().timeout(Duration(minutes: 2));



      // Check response status
      if (streamedResponse.statusCode == 200) {
        final getProfile = jsonDecode(responseBody);

        // Parse response to model
        final profileModel = ProfilePicModel.fromJson(getProfile);
        
        return profileModel; // Return the model
      } else {
        throw Exception('Failed to upload image: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image');
    }
  }
}
