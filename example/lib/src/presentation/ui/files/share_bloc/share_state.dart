part of 'share_bloc.dart';

sealed class ShareState extends Equatable {
  const ShareState();
  
  @override
  List<Object> get props => [];
}

final class ShareInitial extends ShareState {}

final class Sharing extends ShareState{}

final class Shared extends ShareState {
  final ShareEntity response;
  // final String batchhash;

  const Shared(this.response);
}

final class ShareFailed extends ShareState {
  final String message;

  const ShareFailed(this.message);
}


