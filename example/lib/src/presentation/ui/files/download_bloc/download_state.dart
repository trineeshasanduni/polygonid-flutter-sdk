part of 'download_bloc.dart';

sealed class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object> get props => [];
}

final class DownloadInitial extends DownloadState {}

final class Downloading extends DownloadState {
    final String batchhash;
    
    const Downloading(this.batchhash);

}

final class DownloadFailed extends DownloadState {
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
  final String batchhash;

  const DownloadSuccess(this.response,this.batchhash);
}
final class DownloadUrlSuccess extends DownloadState {
  final DownloadUrlEntity response;
  final String batchhash;
  // final String batchhash;

  const DownloadUrlSuccess(this.response,this.batchhash);
}

final class StatusLoaded extends DownloadState {
  final DownloadStatusResponseentity did;
   final String batchhash;

 const StatusLoaded(this.did,this.batchhash);
}

final class GettingCids extends DownloadState {}

final class CidsGot extends DownloadState {
  final CidEntity cids;
  final String batchhash;

 const CidsGot(this.cids,this.batchhash);
}

