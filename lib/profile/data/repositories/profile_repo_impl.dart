import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/profile/data/dataSources/profile_dataSource.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/activityModel.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/activityEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/repositories/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepository {
  final ProfileRemoteDatasource profileRemoteDatasource;

  ProfileRepoImpl({required this.profileRemoteDatasource});

  @override
Future<Either<Failure, ActivityEntity>> activityLogs({
  required String did,
}) async {
  try {
    // Fetching the activity logs from remote datasource
    ActivityModel activityModel = await profileRemoteDatasource.activityLogs(
      did: did,
    );

    // Check if groupedLogs is not null
    if (activityModel.groupedLogs != null) {
      // Map all the grouped logs
      List<GroupedLogs> groupedLogsList = activityModel.groupedLogs!.map((group) {
        return GroupedLogs(
          logs: group.logs!.map((log) {
            // Mapping each log
            return Logs(
              did: log.did!,
              id: log.id!,
              name: log.name!,
              data: log.data!,
              level: log.level!,
              traceId: log.traceId!,
              timestamp: Timestamp(
                seconds: log.timestamp!.seconds!,
                nanos: log.timestamp!.nanos!,
              ),
              humanReadableTimestamp: log.humanReadableTimestamp!,
            );
          }).toList(), // Convert the logs to a list
        );
      }).toList(); // Convert the grouped logs to a list

      // Return the mapped ActivityEntity
      return right(ActivityEntity(groupedLogs: groupedLogsList));
    } else {
      return left(Failure('No grouped logs found'));
    }
  } catch (error) {
    // Return failure if there's an exception
    return left(Failure('Failed to retrieve logs: $error'));
  }
}
}