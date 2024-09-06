import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:polygonid_flutter_sdk/login/data/model/login_modal.dart';
import 'package:polygonid_flutter_sdk/login/data/model/login_status_model.dart';

abstract interface class LoginRemoteDatasource {
  Future<LoginModal> loginDone();

  Future<LoginStatusResponseModel> fetchLoginStatus(String sessionId);
}

class LoginRemoteDatasourceImpl implements LoginRemoteDatasource {
  final http.Client client;


  LoginRemoteDatasourceImpl({required this.client});
  // static const BASE_URL = 'http://192.168.1.10:9000/api/v1';
    static const BASE_URL = 'https://test.becx.io/api/v1';


  @override
  Future<LoginModal> loginDone()  async {
    
    print('fetching login');
    try {
      
      final response = await client.get(Uri.parse('$BASE_URL/sign-in'));
      print('login status: $response');

      print('login status1: ${response.statusCode}');

      if (response.statusCode == 200) {
       
         final Map<String, dynamic> loginDetail = jsonDecode(response.body);
        final headers = response.headers['x-id'];
        print('headers: ${headers}');

        final login = LoginModal.fromJson(loginDetail );
        print('loginbody11: ${login.body?.scope![0].query?.credentialSubject?.auth?.$eq}');

        final loginResponse = LoginModal(
          body: Body(
            callbackUrl: login.body?.callbackUrl,
            reason: login.body?.reason,
            scope: [
              Scope(
                circuitId: login.body?.scope![0].circuitId,
                id: login.body?.scope![0].id,
                query: Query(
                  allowedIssuers: login.body?.scope![0].query?.allowedIssuers,
                  context: login.body?.scope![0].query?.context,
                  credentialSubject: CredentialSubject(
                    auth: Auth(
                      $eq: login.body?.scope![0].query?.credentialSubject?.auth?.$eq,
                    ),
                  ),
                  type: login.body?.scope![0].query?.type,
                ),
              ),
            ],
          ),
          from: login.from,
          id: login.id,
          type: login.type,
          thid: login.thid,
          typ: login.typ,
          headers: headers
        );
        print('loginbody123: ${loginResponse}');

        
        return loginResponse;
      }
       else {
        throw Exception('Failed to load login: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching login: $e');
      throw Exception('Failed to fetch login');
    }
  }

  // Future<LoginStatusResponseModel> fetchLoginStatus(String sessionId) async {
  //   print('sessionId check123: $sessionId');
  //   try {
  //     final response =
  //       await client.get(Uri.parse('https://apimobile.becx.io/api/v1/status?sessionId=$sessionId'));
  //     print('login status1: ${response.statusCode}');
  //     final statusCode = response.statusCode;
  //     final did = jsonDecode(response.body)['id'].toString();
  //     print('getDDID: $did');
  //     return LoginStatusResponseModel(did: did, statusCode: statusCode);
  //   } catch (e) {
  //     print('Error fetching login: $e');
  //     throw Exception('Failed to fetch login');
  //   }
  // }

  Future<LoginStatusResponseModel> fetchLoginStatus(String sessionId) async {
  print('sessionId check123: $sessionId');
  int statusCode = 0;

  while (statusCode != 200) {
    try {
      final response =
          await client.get(Uri.parse('$BASE_URL/status?sessionId=$sessionId'));
      print('login status1: ${response.statusCode}');
      statusCode = response.statusCode;
      
      // If the status is 200, break the loop and return the response
      if (statusCode == 200) {
        final did = jsonDecode(response.body)['id'].toString();
        print('getDDID: $did');
        return LoginStatusResponseModel(did: did, statusCode: statusCode);
      } else {
        print('Waiting for status code 200, received: $statusCode');
      }

      // Wait for a few seconds before the next attempt
      await Future.delayed(Duration(seconds: 5));
    } catch (e) {
      print('Error fetching login status: $e');
      throw Exception('Failed to fetch login');
    }
  }

  throw Exception('Failed to get status 200');
}


  


}





