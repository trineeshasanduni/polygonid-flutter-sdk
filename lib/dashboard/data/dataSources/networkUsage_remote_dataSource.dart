import 'package:polygonid_flutter_sdk/dashboard/data/models/networkUsageModel.dart';

abstract class NetworkRemoteDatasource {
   Future<List<NetworkUsageModel>> networkUsage({
    required String did,
  });}