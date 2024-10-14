import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/common/usecase/usecase.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/activityEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/repositories/profile_repo.dart';

class ProfileUsecase implements UseCase<ActivityEntity, ProfileParams> {
  final ProfileRepository profileRepository;
  const ProfileUsecase(this.profileRepository);

  @override
  Future<Either<Failure, ActivityEntity>> call(ProfileParams params) async {
    print('registering12: ${params.did}');
    return await profileRepository.activityLogs(
      did: params.did,
  
    );
  }
}

class ProfileParams {
  final String did;

  ProfileParams({
    required this.did,
    
  });
}