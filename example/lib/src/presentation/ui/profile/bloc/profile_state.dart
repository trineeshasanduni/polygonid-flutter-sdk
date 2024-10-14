part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class LogsUpdating extends ProfileState {}

final class LogsUpdated extends ProfileState {
  final ActivityEntity logs;

  const LogsUpdated(this.logs);
}

final class LogsUpdateFailed extends ProfileState {
  final String message;

  const LogsUpdateFailed(this.message);
}




