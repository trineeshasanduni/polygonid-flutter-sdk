import 'package:polygonid_flutter_sdk/profile/data/models/activityModel.dart';

abstract class ProfileRemoteDatasource {
  Future<ActivityModel> activityLogs({
    required String did,
  });}