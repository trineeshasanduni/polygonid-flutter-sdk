import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polygonid_flutter_sdk/dashboard/data/dataSources/networkUsage_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/dashboard/data/models/networkUsageModel.dart';

import '../../models/networkUsageModel.dart';

class NetworkRemoteDatasourceImpl implements NetworkRemoteDatasource {
  final http.Client client;

  NetworkRemoteDatasourceImpl({required this.client});

  static const BASE_URL = 'https://test.becx.io/api/v1';

  @override
  Future<List<NetworkUsageModel>> networkUsage({required String did}) async {
    print('Fetching network usage');
    final Did = jsonDecode(did);
    print('Did123: $Did');
    try {
      final response = await client.get(
        Uri.parse('$BASE_URL/network-usage?OwnerDid=$Did'),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = jsonDecode(response.body);
        
        // Parse the list of network usage data into a list of NetworkUsageModel
        final List<NetworkUsageModel> networkUsageList = decodedJson.map((jsonItem) {
          return NetworkUsageModel.fromJson(jsonItem);
        }).toList();

        print('Network usage response: $networkUsageList');
        return networkUsageList;
      } else {
        throw Exception('Failed to fetch network usage, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching network usage: $e');
      throw Exception('Failed to fetch network usage');
    }
  }
}
