part of 'download_bloc.dart';

sealed class DownloadState extends Equatable {
  const DownloadState();
  
  @override
  List<Object> get props => [];
}

final class DownloadInitial extends DownloadState {}

final class Downloading extends DownloadState{}

final class DownloadFailed extends DownloadState{
  final String message;

  const DownloadFailed(this.message);
}

final class loaded extends DownloadState {
  final Iden3MessageEntity iden3message;

  loaded(this.iden3message);
}

final class downlodVerified extends DownloadState {
  const downlodVerified();
}
final class DownloadSuccess extends DownloadState {
  final DownloadVerifyEntity response;

  const DownloadSuccess(this.response);
}

final class StatusLoaded extends DownloadState {
    final DownloadStatusResponseentity did;

    StatusLoaded(this.did);
  }
