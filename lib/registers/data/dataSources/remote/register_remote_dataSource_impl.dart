
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:polygonid_flutter_sdk/registers/data/dataSources/register_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/registers/data/model/register_model.dart';

class RegisterRemoteDatasourceImpl implements RegisterRemoteDatasource {
  final http.Client client;

  RegisterRemoteDatasourceImpl({required this.client});

  static const BASE_URL = 'https://apimobile.becx.io/api/v1';

  @override
  Future<RegisterModel> registerWithDID({
    required String did,
    required String first,
    required String last,
    required String email,
  }) async {
    try {
      // Construct the data to be sent
      Map<String, dynamic> data = {
        "DID": did,
        "First": first,
        "Last": last,
        "Email": email,
      };
      print('Signup data: $data');

      // Define the URI for the sign-up API endpoint
      final uri = Uri.parse('$BASE_URL/sign-up');

      // Make the POST request with the proper headers and body
      final response = await client.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('Signup status code: ${response.statusCode}');

      // Check for a successful status code
      if (response.statusCode == 201) {
        // Parse the response body
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        print('jsonResponse56: $jsonResponse');
        final claim = jsonResponse['claim'] as Map<String, dynamic>;
        print('claim12: $claim');
        // final body = jsonEncode(claim);
        final registerResponse = RegisterModel.fromJson(claim);

      print('registerResponse11: ${registerResponse.body?.url}');

        // Log the request and response details
        // print('Register Request: $claim');
        // print('Register Response Body: ${response.body}');
        // print('object: ${body}');
        // print('registermodel: ${RegisterModel.fromJson(claim).body?.url}');
        final registerModel = RegisterModel(
          body: Body(
            credentials: [
              Credentials(
                description: registerResponse.body?.credentials![0].description,
                id: registerResponse.body?.credentials![0].id,
              ),
            ],
            url: registerResponse.body?.url,
          ),
          from: registerResponse.from,
          id: registerResponse.id,
          thid: registerResponse.thid,
          to: registerResponse.to,
          typ: registerResponse.typ,
          type: registerResponse.type,
        );
        print('registerModel1: $registerModel');

        // Return the RegisterModel
        return registerModel;
      } else {
        // Log the failure and throw a custom exception
        print('Failed to register with status code: ${response.statusCode}');
        throw Exception(
            'Failed to register with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during registration: $error');
      throw Exception('Failed to register');
    }
  }
}
