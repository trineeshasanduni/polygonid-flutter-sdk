part of 'download_bloc.dart';

sealed class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object> get props => [];
}

final class DownloadInitial extends DownloadState {}

final class Downloading extends DownloadState {
    final String batchhash;
    final double progress; 
        final String fileHash;

    
    const Downloading(this.batchhash,this.progress,this.fileHash);

}

final class LoadingUrl extends DownloadState {
    final String batchhash;
     final String fileHash;
     
    
    const LoadingUrl(this.batchhash, this.fileHash);

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
  final String fileHash;

  const DownloadSuccess(this.response,this.batchhash,this.fileHash);
}

final class DownloadZip extends DownloadState {
  final DownloadZipEntity response;
  final String batchhash;
  final String fileHash;

  const DownloadZip(this.response,this.batchhash,this.fileHash);
}
final class DownloadUrlSuccess extends DownloadState {
 
  final DownloadUrlEntity response;
  final String batchhash;
  final String fileHash;
  

  const DownloadUrlSuccess(this.response,this.batchhash,this.fileHash);
   
}

final class StatusLoaded extends DownloadState {
  final DownloadStatusResponseentity did;
   final String batchhash;
   final String fileHash;

 const StatusLoaded(this.did,this.batchhash,this.fileHash);
}

final class GettingCids extends DownloadState {}

final class CidsGot extends DownloadState {
  final CidEntity cids;
  final String batchhash;
  final String fileHAsh;

 const CidsGot(this.cids,this.batchhash,this.fileHAsh);
}

final class BatchCidsGot extends DownloadState {
  final List<CidEntity> cids;
  final String batchhash;
  final String fileHAsh;

 const BatchCidsGot(this.cids,this.batchhash,this.fileHAsh);
}


