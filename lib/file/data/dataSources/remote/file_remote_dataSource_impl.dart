import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:polygonid_flutter_sdk/file/data/dataSources/file_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/file/data/model/file_entity.dart';
import 'package:polygonid_flutter_sdk/registers/data/dataSources/register_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/registers/data/model/register_model.dart';

class FileRemoteDatasourceImpl implements FileRemoteDatasource {
  final http.Client client;

  FileRemoteDatasourceImpl({required this.client});

  static const BASE_URL = 'https://apimobile.becx.io/api/v1';
  
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

      print('request: $request');

      // Send the request
      var response = await request.send();

      // Get the response
      final responseBody = await response.stream.bytesToString();
      print('Upload file status code: ${response.statusCode}');
      print('Upload file response body: $responseBody');

      if (response.statusCode == 201) {
        final responseJson = jsonDecode(responseBody);
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

}
