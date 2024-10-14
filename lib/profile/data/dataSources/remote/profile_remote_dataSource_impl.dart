import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:polygonid_flutter_sdk/profile/data/dataSources/profile_dataSource.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/activityModel.dart';

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
      // print('file name status: ${response.body}');

      print('file name status1: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('fetch file name status code: ${response.statusCode}');
        final  activityLogsList = jsonDecode(response.body);
        final activityLogs = activityLogsList["grouped_logs"];
        // final activityLogsq = activityLogs["grouped_logs"];
        print('grouped_logs: $activityLogs');
        // print('activityLogsList: $activityLogsList');

        // Assuming the response is a list of objects, use the first item
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
}
