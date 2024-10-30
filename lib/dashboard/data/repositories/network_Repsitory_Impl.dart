import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/dashboard/data/dataSources/networkUsage_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/dashboard/data/models/networkUsageModel.dart';
import 'package:polygonid_flutter_sdk/dashboard/domain/entities/networkUsageEntity.dart';
import 'package:polygonid_flutter_sdk/dashboard/domain/repositories/network_repository.dart';

class NetworkRepsitoryImpl implements NetworkRepository {
  final NetworkRemoteDatasource networkRemoteDatasource;

  NetworkRepsitoryImpl({required this.networkRemoteDatasource});

  @override
  Future<Either<Failure, List<NetworkUsageEntity>>> networkUsage({required String did}) async {
    print('Fetching network usage...');
    try {
      // Fetch list of NetworkUsageModel from the remote data source
      final List<NetworkUsageModel> networkUsageModelList = 
          await networkRemoteDatasource.networkUsage(did: did);

      // Map the list of NetworkUsageModel to a list of NetworkUsageEntity
      final List<NetworkUsageEntity> networkUsageEntities = networkUsageModelList.map((model) {
        return NetworkUsageEntity(
          day: model.day, // Map the 'day' field
          dailyUsage: model.dailyUsage, // Map the 'dailyUsage' field
        );
      }).toList();
      print(' Network usage response impl: ${networkUsageEntities[4].dailyUsage}');
      
      // Return the successfully fetched and mapped list of entities
      return right(networkUsageEntities);
    } catch (e) {
      print('Error occurred while fetching network usage: $e');
      // Return a specific failure
      return left(Failure());
    }
  }
}
