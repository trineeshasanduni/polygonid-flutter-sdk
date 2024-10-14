part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ActivityLogsEvent extends ProfileEvent {
  final String did;

  const ActivityLogsEvent({
    required this.did,
  });


}
