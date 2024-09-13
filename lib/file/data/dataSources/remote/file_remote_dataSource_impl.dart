import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:polygonid_flutter_sdk/file/data/dataSources/file_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/file/data/model/fileName_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/file_model.dart';
import 'package:polygonid_flutter_sdk/registers/data/dataSources/register_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/registers/data/model/register_model.dart';

class FileRemoteDatasourceImpl implements FileRemoteDatasource {
  final http.Client client;

  FileRemoteDatasourceImpl({required this.client});

  // static const BASE_URL = 'https://apimobile.becx.io/api/v1';
  static const BASE_URL = 'http://192.168.1.42:9000/api/v1';
  
  @override
  Future<FileModel> fileUpload({required String did, required String ownerDid, required File fileData}) async{
    print('Uploading file');
    try {
      // Define the URI for the upload API endpoint
      final uri = Uri.parse('$BASE_URL/upload');

      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', uri)
        ..fields['did'] = did
        ..fields['owner'] = ownerDid
        ..files
            .add(await http.MultipartFile.fromPath('fileData', fileData.path));
            print('did file: $did');
            print('ownerDid file: $ownerDid');
            print('fileData file: $fileData');

      print('request: $request');

      // Send the request
      var response = await request.send();

      // Get the response
      final responseBody = await response.stream.bytesToString();
      print('Upload file status code: ${response.statusCode}');
      print('Upload file response body: $responseBody');

      if (response.statusCode == 201) {
        print('successfully uploaded file');
        final responseJson = jsonDecode(responseBody);
        print('object responseJson: $responseJson');
        return FileModel.fromJson(responseJson);
        
      } else {
        print('Failed to upload file');
        throw Exception('Failed to upload file');
      }
    } catch (error) {
      print('Error during file upload: $error');
      throw Exception('Failed to upload file');
    }
  }
  
  
  @override
  Future<FileModel> useSpace({required String did, required String ownerDid, required int batchSize}) async{
    print('Using space');
    try {
       Map<String, dynamic> data = {
        "BatchSize": batchSize,
        "DID": did,
        "Owner":ownerDid 
      };
      // Define the URI for the use-space API endpoint
      final uri = Uri.parse('$BASE_URL/use-space');

      // Make the POST request with the proper headers and body
      final response = await client.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('data use space: $data');

      print('Use space status code: ${response.statusCode}');
Map<String, dynamic> jsonResponse = jsonDecode(response.body);
       final responseProof = FileModel.fromJson(jsonResponse);
      final fileResponse = FileModel(
       TXHash: responseProof.TXHash,
      );

      if (response.statusCode == 200) {

        
        return fileResponse;
      } else {
        print('Failed to use space');
        throw Exception('Failed to use space');
      }
    } catch (error) {
      print('Error during use space: $error');
      throw Exception('Failed to use space');
    }

   
    
  }

  @override
  Future<FileNameModel> getFileName(String BatchHash) async {
  print('fetching file name');
  try {
    final response = await client
        .get(Uri.parse('$BASE_URL/get-filename?BatchHash=$BatchHash'));
    // print('file name status: ${response.body}');

    print('file name status1: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('fetch file name status code: ${response.statusCode}');
      final List<dynamic> fileNameList = jsonDecode(response.body);

      // Assuming the response is a list of objects, use the first item
      if (fileNameList.isNotEmpty) {
        final fileNameJson = fileNameList[0] as Map<String, dynamic>;

        final fileNameModel = FileNameModel.fromJson(fileNameJson);
        print("fileName response: $fileNameModel");
        return fileNameModel;
      } else {
        throw Exception('No data found in the response');
      }
    } else {
      throw Exception('Failed to load file name: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching file name: $e');
    throw Exception('Failed to fetch file name');
  }
}


}
