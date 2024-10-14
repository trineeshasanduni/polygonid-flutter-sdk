import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/activityEntity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ActivityEntity>> activityLogs({
    required String did,
    
  });}