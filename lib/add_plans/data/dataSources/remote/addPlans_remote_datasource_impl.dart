import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:polygonid_flutter_sdk/add_plans/data/model/addPlans_model.dart';
import 'package:polygonid_flutter_sdk/add_plans/data/model/freeSpace_model.dart';
import 'package:polygonid_flutter_sdk/login/data/model/login_modal.dart';
import 'package:polygonid_flutter_sdk/login/data/model/login_status_model.dart';

abstract interface class AddPlansRemoteDatasource {
  Future<AddPlansModel> genetateSecrets();
  Future<AddPlansModel> addUser(
      {required String Commitment,
      required String Did,
      required String NullifierHash,
      required String Owner});
  Future<AddPlansModel> createProof(
      {required String account, required String txhash});
  Future<AddPlansModel> verifyUser(
      {required List<String> A,
      required List<List<String>> B,
      required List<String> C,
      required List<String> Inputs,
      required String Owner,
      required String Did});

  Future<FreeSpaceModel> freeSpace({required String did, required String owner});

  
}

class AddPlansRemoteDatasourceImpl implements AddPlansRemoteDatasource {
  final http.Client client;

  AddPlansRemoteDatasourceImpl({required this.client});
  // static const BASE_URL = 'http://192.168.1.42:9000/api/v1';
  static const BASE_URL = 'https://test.becx.io/api/v1';

  @override
  Future<AddPlansModel> genetateSecrets() async {
    print('fetching add plans');
    try {
      final response = await client
          .get(Uri.parse('http://adduser.bethel.network/generate-secrets'));
      print('add plans status: ${response.body}');

      print('add plans status1: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> addPlans = jsonDecode(response.body);

        final addPlansResponse = AddPlansModel.fromJson(addPlans);
        final response1 = AddPlansModel(
          commitment: addPlansResponse.commitment,
          nullifierHash: addPlansResponse.nullifierHash,
        );
        print('add plans response: ${response1}.');
        return response1;
      } else {
        throw Exception('Failed to load login: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching add plans: $e');
      throw Exception('Failed to fetch login');
    }
  }

  @override
  Future<AddPlansModel> addUser(
    {required String Commitment,
    required String Did,
    required String NullifierHash,
    required String Owner}) async {
  print('add user up');
  try {
    final did = jsonDecode(Did);
    Map<String, dynamic> data = {
      "Commitment": Commitment,
      "Did": did,
      "NullifierHash": NullifierHash,
      "Owner": Owner,
    };
    print('add user data: $data');

    final uri = Uri.parse('$BASE_URL/add-user');
    final response = await http.post(
      uri,
      body: jsonEncode(data),
    );
    print('add user status code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      // Decode the response
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('adduserJsonResponse: $jsonResponse');

      // Ensure TXHash exists in the response
      if (jsonResponse.containsKey('TXHash')) {
        final txHash = jsonResponse['TXHash'];
        print('addUser TXHash: $txHash');

        // Return the AddPlansModel with the TXHash
        return AddPlansModel(TXHash: txHash);
      } else {
        print('Error: TXHash not found in response');
        throw Exception('TXHash not found in the response');
      }
    } else {
      print('Error: Failed to add user, status code: ${response.statusCode}');
      throw Exception('Failed to add user with status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error during add user: $error');
    throw Exception('Failed to add user: $error');
  }
}


  @override
  Future<AddPlansModel> createProof(
      {required String account, required String txhash}) async {
    try {
      Map<String, dynamic> data = {
        "account": account,
        "txhash": txhash, // Using the TXHash from addUser here
      };
      print('create proof data: $data');

      final uri = Uri.parse('http://adduser.bethel.network/createproof');
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('create proof status code: ${response.statusCode}');

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseProof = AddPlansModel.fromJson(jsonResponse);
      final createProofResponse = AddPlansModel(
        a: responseProof.a,
        b: responseProof.b,
        c: responseProof.c,
        input: responseProof.input,
      );

      if (response.statusCode == 200) {
        return createProofResponse;
      } else {
        throw Exception('Failed to create proof');
      }
    } catch (error) {
      print('Error during create proof: $error');
      throw Exception('Failed to create proof');
    }
  }

  @override
Future<AddPlansModel> verifyUser({
  required List<String> A,
  required List<List<String>> B,
  required List<String> C,
  required List<String> Inputs,
  required String Owner,
  required String Did,
}) async {
  try {
    // Convert BigInt lists to List<String> for JSON serialization
    List<String> aList = A.map((e) => e.toString()).toList();
    List<List<String>> bList = B.map((e) => e.map((e) => e.toString()).toList()).toList();
    List<String> cList = C.map((e) => e.toString()).toList();

    //convert to string

    final did = jsonDecode(Did);
    print('did verify11: $did');
    print('inputs verify11: $Inputs');
    final owner = jsonEncode(Owner);
    final aLista =jsonEncode(aList);
    final bLista =jsonEncode(bList);
    final cLista =jsonEncode(cList);
    final inputs= jsonEncode(Inputs);
    final did1 = jsonEncode(did);


    print('aList verify: $aList');
    print('bList verify: $bList');
    print('cList verify: $cList');
    print('did verify111: $did1');

print('owner verify: $Owner');
    // Construct the data to be sent
    Map<String, dynamic> data = {
      "A": aLista,
      "B": bLista,
      "C": cLista,
      "Inputs": inputs,
      "Did": did,
      "Owner": Owner,
    };
    print('verify user data: $data');

    print('did verify: $Did');
    print('owner verify: $Owner');

    // Define the URI for the sign-up API endpoint
    final uri = Uri.parse('$BASE_URL/verify-user');

    // Make the POST request with the proper headers and body
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    print('verify user status code: ${response.statusCode}');
    print('verify user Response Body: ${response.body}');

    // Decode the response
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    // Create an instance of AddPlansModel from the response
    final addUserResponse = AddPlansModel.fromJson(jsonResponse);
    final verifyUserResponse = addUserResponse.TXHash;
    print('addUser TXHash1: $verifyUserResponse');

    if (response.statusCode == 200) {
      return AddPlansModel(TXHash: verifyUserResponse);
    } else {
      print('Failed to verify user');
      throw Exception('Failed to verify user');
    }
  } catch (error) {
    print('Error during verify user: $error');
    throw Exception('Failed to verify user');
  }
}

 @override
  Future<FreeSpaceModel> freeSpace({required String did, required String owner}) async{
    try {
       final Did = jsonDecode(did);
       print('did free space: $Did');
      Map<String, dynamic> data = {
        "DID": Did,
        "Owner": owner, // Using the TXHash from addUser here
      };
      print('space data: $data');

      final uri = Uri.parse('$BASE_URL/free-space');
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('space status code: ${response.statusCode}');

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
      final responseProof = FreeSpaceModel.fromJson(jsonResponse);
      final spaceResponse =FreeSpaceModel(
        TXHash: responseProof.TXHash,
      );
      

      if (response.statusCode == 200) {
        print('space response: ${spaceResponse.TXHash}');
        return spaceResponse;
      } else {
        throw Exception('Failed to space');
      }
    } catch (error) {
      print('Error during space: $error');
      throw Exception('Failed to space');
    }
  }

  

  
}
