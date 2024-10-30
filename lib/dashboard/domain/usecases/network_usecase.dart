import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/common/usecase/usecase.dart';
import 'package:polygonid_flutter_sdk/dashboard/domain/entities/networkUsageEntity.dart';
import 'package:polygonid_flutter_sdk/dashboard/domain/repositories/network_repository.dart';

class NetworkUsageUsecase
    implements UseCases<NetworkUsageEntity, UseCaseParams> {
  final NetworkRepository networkRepository;
  const NetworkUsageUsecase(this.networkRepository);
  @override
  Future<Either<Failure, List<NetworkUsageEntity>>> call(UseCaseParams params) async {
    print('registering123: ${params.did}');
    return await networkRepository.networkUsage(did: params.did);
  }
}

class UseCaseParams {
  final String did;

  UseCaseParams({required this.did});
}
