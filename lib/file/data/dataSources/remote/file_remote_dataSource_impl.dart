import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:polygonid_flutter_sdk/file/data/dataSources/file_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/file/data/model/cid_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/downloadUrl_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/downloadVerify_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/download_status_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/fileName_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/file_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/share_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/verify_share_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/verify_upload_model.dart';
import 'package:polygonid_flutter_sdk/registers/data/dataSources/register_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/registers/data/model/register_model.dart';

class FileRemoteDatasourceImpl implements FileRemoteDatasource {
  final http.Client client;

  FileRemoteDatasourceImpl({required this.client});

  static const BASE_URL = 'https://test.becx.io/api/v1';
  // static const BASE_URL = 'http://192.168.1.42:9000/api/v1';



Future<FileModel> fileUpload({
  required String did,
  required String ownerDid,
  required List<File> files,
}) async {
  print('Starting file upload...');
  try {
    final uri = Uri.parse('$BASE_URL/upload');
    var request = http.MultipartRequest('POST', uri)
      ..fields['did'] = did
      ..fields['owner'] = ownerDid;

    // Create a list to hold all the MultipartFile instances
    List<http.MultipartFile> multipartFiles = [];

    // Add each file to the list and log its details
    for (var file in files) {
      if (!await file.exists()) {
        throw Exception('File not found: ${file.path}');
      }

      var multipartFile = await http.MultipartFile.fromPath(
        'fileData', // Adjust this to match the server's expected field name
        file.path,
      );

      

      multipartFiles.add(multipartFile);

      // Log file information
      print('Added file: ${file.path.split('/').last} - Size: ${await file.length()} bytes');
    }

    // Add all files to the request at once using addAll
    request.files.addAll(multipartFiles);

    // Confirm that only one request will be sent with all files
    print('Prepared single multipart request with ${request.files.length} file(s)');
    print('Request content length: ${request.contentLength}');

    // Send the request
    var response = await request.send();

    // Read the response
    print('Response status: ${response.statusCode}');
    final responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');

    if (response.statusCode == 201) {
      print('Successfully uploaded files');

      // Decode the response JSON
      final decodedResponse = jsonDecode(responseBody);
      print('Decoded response: $decodedResponse');

      // Parse the response based on the expected format
      if (decodedResponse is Map &&
          decodedResponse.containsKey('Did') &&
          decodedResponse.containsKey('TXHash') &&
          decodedResponse.containsKey('FileCount')) {
        return FileModel.fromJson(decodedResponse as Map<String, dynamic>);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      print('Failed to upload files. Status code: ${response.statusCode}');
      print('Response body: $responseBody');
      throw Exception('Failed to upload files');
    }
  } catch (error) {
    print('Error during file upload: $error');
    throw Exception('Failed to upload files');
  }
}





  @override
  Future<FileModel> useSpace(
      {required String did,
      required String ownerDid,
      required int batchSize}) async {
    print('Using space');
    try {
      Map<String, dynamic> data = {
        "BatchSize": batchSize,
        "DID": did,
        "Owner": ownerDid
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
Future<List<FileNameModel>> getFileName(String BatchHash, String Verify) async {
  print('Fetching file names');
  try {
    final response = await client.get(
      Uri.parse('$BASE_URL/get-filename?BatchHash=$BatchHash'),
    );
    print('File name status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Fetch file name status code: ${response.statusCode}');
      final List<dynamic> fileNameList = jsonDecode(response.body);

      if (fileNameList.isNotEmpty) {
        // Parse each entry in the response list to a FileNameModel
        final List<FileNameModel> fileNames = fileNameList.map((fileJson) {
          final fileNameJson = fileJson as Map<String, dynamic>;
          return FileNameModel(
            fileHash: fileNameJson['FileHash'],
            fileName: fileNameJson['FileName'],
            batchHash: BatchHash,
            isVerified: Verify == 'true',
          );
        }).toList();

        print("File names fetched: $fileNames");
        return fileNames;
      } else {
        throw Exception('No data found in the response');
      }
    } else {
      throw Exception('Failed to load file names: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching file names: $e');
    throw Exception('Failed to fetch file names');
  }
}


  @override
  Future<VerifyUploadModel> verifyUpload({
    required String BatchHash,
    required String did,
    required String ownerDid,
  }) async {
    print('Fetching verify upload');

    try {
      print('did verify: $did');
      print('batchHash verify: $BatchHash');
      print('owner Did verify: $ownerDid');
      final response = await client.get(Uri.parse(
          '$BASE_URL/get-claim?Did=$did&BatchHash=$BatchHash&ownerAddress=$ownerDid'));

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> verify = jsonDecode(response.body);
        print('Decoded JSON: $verify');

        // Now we need to parse the `claim` field which is a string
        final String claimString = verify['claim'];
        final Map<String, dynamic> claim = jsonDecode(claimString);
        print('Decoded Claim JSON: $claim');

        // Convert it back into your model
        final verifyResponse = VerifyUploadModel(
          claim: ClaimVerifyModel.fromJson(claim), // Use the parsed claim JSON
          txHash: verify['txHash'],
        );

        print('VerifyUploadModel: $verifyResponse');
        return verifyResponse;
      } else {
        throw Exception('Failed to load verify: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching verify upload: $e');
      throw Exception('Failed to fetch verify upload');
    }
  }

////////////////////////////Download verify///////////////////////////////

  @override
  Future<DownloadVerifyModel> downloadVerify(
      {required String BatchHash,
      required String FileHash,
      required String Odid}) async {
    print('Using space dowload');
    try {
      Map<String, dynamic> data = {
        "BatchHash": BatchHash,
        "FileHash": FileHash,
        "Odid": Odid
      };
      // Define the URI for the use-space API endpoint
      final uri = Uri.parse('$BASE_URL/download-verify');

      // Make the POST request with the proper headers and body
      final response = await client.post(
        uri,
        // headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('data Download Verify: $data');

      print('Download Verify status code: ${response.statusCode}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final headers = response.headers['x-iid'];
      print('header downoload: $headers ');
      final responsedown = DownloadVerifyModel.fromJson(jsonResponse);

      final DownloadResponse = DownloadVerifyModel(
          body: BodyDownload(
              callbackUrl: responsedown.body?.callbackUrl!,
              reason: responsedown.body?.reason,
              scope: [
                ScopeDownload(
                  circuitId: responsedown.body?.scope![0].circuitId,
                  id: responsedown.body?.scope![0].id,
                  query: QueryDownload(
                    allowedIssuers:
                        responsedown.body?.scope![0].query?.allowedIssuers,
                    context: responsedown.body?.scope![0].query?.context,
                    credentialSubject: CredentialSubject(
                      hash: Hash(
                        $eq: responsedown.body?.scope![0].query
                            ?.credentialSubject?.hash?.$eq,
                      ),
                    ),
                    type: responsedown.body?.scope![0].query?.type,
                  ),
                ),
              ]),
          from: responsedown.from,
          id: responsedown.id,
          type: responsedown.type,
          thid: responsedown.thid,
          typ: responsedown.typ,
          sessionId: headers);

      if (response.statusCode == 200) {
        return DownloadResponse;
      } else {
        print('Failed to Download Verify');
        throw Exception('Failed to Download Verify');
      }
    } catch (error) {
      print('Error during Download Verify: $error');
      throw Exception('Failed to Download Verify');
    }
  }

  Future<DownloadStatusResponseModel> fetchDownloadStatus(
      String sessionId) async {
    print('sessionId download check123: $sessionId');
    int statusCode = 0;

    while (statusCode != 200) {
      try {
        final response = await client
            .get(Uri.parse('$BASE_URL/batchfilestatus?sessionId=$sessionId'));
        print('download status1: ${response.statusCode}');
        statusCode = response.statusCode;

        // If the status is 200, break the loop and return the response
        if (statusCode == 200) {
          return DownloadStatusResponseModel(statusCode: statusCode);
        } else {
          print('Waiting for status code 200, received: $statusCode');
        }

        // Wait for a few seconds before the next attempt
        await Future.delayed(Duration(seconds: 5));
      } catch (e) {
        print('Error fetching download status: $e');
        throw Exception('Failed to fetch download');
      }
    }

    throw Exception('Failed to get status 200');
  }

  @override
  Future<CidModel> getCids(
      dynamic index, String did, String owner, String BatchHash) async {
    print('Fetching CIDs');
    try {
      final response = await http.get(Uri.parse(
          '$BASE_URL/get-cid?Index=$index&Did=$did&OwnerAddress=$owner'));

      // Log the response body
      print('Response body: ${response.body}');

      // Check if the response is successful
      if (response.statusCode == 200) {
        print('Fetch CIDs status code: ${response.statusCode}');

        // Decode the response body (which should be a JSON string)
        dynamic decodedResponse = await jsonDecode(response.body);

        // If the decoded response is a string, decode it again
        if (decodedResponse is String) {
          print('Decoded response is a String, parsing again');
          decodedResponse = await jsonDecode(decodedResponse);
        }

        // Ensure that `decodedResponse` is a List of dynamic objects
        List<dynamic> data = decodedResponse as List<dynamic>;
        print('Data: ${data.runtimeType}');

        // Extract the 'Cid' field from each object and store them in a List<String>
        List<String> cids = data.map((item) => item['Cid'].toString()).toList();

        // Print the extracted CIDs
        print('CIDs: $cids');

        // Return a CidModel containing the list of CIDs
        return CidModel(cids: cids, batchhash: BatchHash);
      } else {
        throw Exception('Failed to load CIDs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching CIDs: $e');
      throw Exception('Failed to fetch CIDs');
    }
  }

  @override
  Future<DownloadUrlModel> download(
      {required String BatchHash,
      required String FileHash,
      required String Odid,
      required String FileName,
      required String Cids}) async {
    print('Using space dowload');
    try {
      Map<String, dynamic> data = {
        "BatchHash": BatchHash,
        "FileHash": FileHash,
        "FileName": FileName,
        "Odid": Odid,
        "Cids": Cids
      };
      // Define the URI for the use-space API endpoint
      final uri = Uri.parse('$BASE_URL/download');

      // Make the POST request with the proper headers and body
      final response = await client.post(
        uri,
        body: jsonEncode(data),
      );
      print('data Download : $data');

      print('Download  status code: ${response.statusCode}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      final responsedown = DownloadUrlModel.fromJson(jsonResponse);

      final DownloadResponse = DownloadUrlModel(
        dID: responsedown.dID,
        uRL: responsedown.uRL,
      );

      if (response.statusCode == 201) {
        return DownloadResponse;
      } else {
        print('Failed to Download ');
        throw Exception('Failed to Download ');
      }
    } catch (error) {
      print('Error during Download : $error');
      throw Exception('Failed to Download ');
    }
  }

  ///////////////////////////////share////////////////////////////
  ///
  @override
  Future<ShareModel> share(
      {required String BatchHash,
      required String FileHash,
      required String OwnerDid,
      required String FileName,
      required String ShareDid,
      required String Owner}) async {
    print('Using space dowload');
    try {
      Map<String, dynamic> data = {
        "OwnerDid": OwnerDid,
        "ShareDid": ShareDid,
        "BatchHash": BatchHash,
        "FileHash": FileHash,
        "Owner": Owner,
        "FileName": FileName
      };
      // Define the URI for the use-space API endpoint
      final uri = Uri.parse('$BASE_URL/shareclaim');

      // Make the POST request with the proper headers and body
      final response = await client.post(
        uri,
        body: jsonEncode(data),
      );
      print('data Share : $data');

      print('Share  status code: ${response.statusCode}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      final responseShare = ShareModel.fromJson(jsonResponse);

      final ShareResponse = ShareModel(
        tXHash: responseShare.tXHash,
        ownerDid: responseShare.ownerDid,
        
      );

      if (response.statusCode == 201) {
        return ShareResponse;
      } else {
        print('Failed to Share ');
        throw Exception('Failed to Share ');
      }
    } catch (error) {
      print('Error during Share : $error');
      throw Exception('Failed to Share ');
    }
  }

  @override
  Future<VerifyShareModel> shareVerifyUpload({
  required String BatchHash,
  required String FileHash,
  required String Did,
  required String OwnerAddress,
}) async {
  print('Fetching share verify upload');

  try {
    // Prepare the request data
    Map<String, dynamic> data = {
      "BatchHash": BatchHash,
      "FileHash": FileHash,
      "Did": Did,
      "OwnerAddress": OwnerAddress,
    };

    print('data share verify: $data');

    // Define the URI for the use-space API endpoint
    final uri = Uri.parse('$BASE_URL/getshareclaim');

    // Make the POST request with the proper headers and body
    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json', // Set content type as JSON
      },
      body: jsonEncode(data), // Encode the data as JSON
    );

    // Log the response status code and body
    print('Status Code: ${response.statusCode}');
    print('Response share Body: ${response.body.toString()}');

    if (response.statusCode == 200) {
      // Check if the body is not empty
      if (response.body.isNotEmpty) {
        // Decode the JSON response
        final  verifyJson = jsonDecode(response.body.toString());
        print('Decoded share JSON: $verifyJson');

        final  verifyJson2 = jsonDecode(verifyJson);
        print('Decoded share JSON2: $verifyJson2');
        

        // Convert it to VerifyShareModel using fromJson or a similar method
        final verifyShareModel = VerifyShareModel.fromJson(verifyJson2);
        print('VerifyUploadModel share: $verifyShareModel');

        return verifyShareModel;
      } else {
        // Handle the case when the body is empty (if that's expected in some cases)
        throw Exception('Response body is empty');
      }
    } else {
      // Handle non-200 responses
      throw Exception('Failed to load share verify: ${response.statusCode}');
    }
  } catch (e) {
    // Catch and print any errors
    print('Error fetching share verify upload: $e');
    throw Exception('Failed to fetch share verify upload');
  }
}

}
