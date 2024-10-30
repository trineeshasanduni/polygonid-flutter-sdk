import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/dashboard/domain/entities/networkUsageEntity.dart';

import '../../../common/errors/server_failure.dart';

abstract class NetworkRepository{
  Future<Either<Failure,List<NetworkUsageEntity>>> networkUsage({required String did});}