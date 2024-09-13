// import 'dart:convert';
// import 'dart:ffi';

// import 'package:http/http.dart' as http;
// import 'package:polygonid_flutter_sdk/add_space/data/model/freeSpace_model.dart';

// import 'package:polygonid_flutter_sdk/login/data/model/login_modal.dart';
// import 'package:polygonid_flutter_sdk/login/data/model/login_status_model.dart';

// abstract interface class AddSpaceRemoteDatasource {
  

//   Future<FreeSpaceModel> freeSpace({required String did, required String owner});
// }

// class AddSpaceRemoteDatasourceImpl implements AddSpaceRemoteDatasource {
//   late final http.Client client;

//   AddSpaceRemoteDatasourceImpl({required this.client});
//   static const BASE_URL = 'https://apimobile.becx.io/api/v1';
//   // static const BASE_URL = 'http://192.168.1.246:3000/api/v1';

  

//   @override
//   Future<FreeSpaceModel> freeSpace({required String did, required String owner}) async{
//     try {
//       Map<String, dynamic> data = {
//         "DID": did,
//         "Owner": owner, // Using the TXHash from addUser here
//       };
//       print('space data: $data');

//       final uri = Uri.parse('$BASE_URL/free-space');
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(data),
//       );
//       print('space status code: ${response.statusCode}');

//       Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
//       final responseProof = FreeSpaceModel.fromJson(jsonResponse);
//       final spaceResponse =FreeSpaceModel(
//         TXHash: responseProof.TXHash,
//       );
      

//       if (response.statusCode == 200) {
//         print('space response: ${spaceResponse.TXHash}');
//         return spaceResponse;
//       } else {
//         throw Exception('Failed to space');
//       }
//     } catch (error) {
//       print('Error during space: $error');
//       throw Exception('Failed to space');
//     }
//   }

  
// }
