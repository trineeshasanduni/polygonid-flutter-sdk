import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/activityModel.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/activityEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/usecases/profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUsecase profileUsecase;

  ProfileBloc(this.profileUsecase) : super(ProfileInitial()) {
    on<ActivityLogsEvent>(_handleActivityLogs);
  }

  void _handleActivityLogs(
      ActivityLogsEvent event, Emitter<ProfileState> emit) async {
    emit(LogsUpdating());
    final uploadResponse = await profileUsecase(ProfileParams(did: event.did));
    uploadResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(LogsUpdateFailed(failure.toString()));
      },
      (upload) {
        print('Emitting StatusLoaded with DID: $upload');
        emit(LogsUpdated(upload ));
      },
    );
  }
}
