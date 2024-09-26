part of 'download_bloc.dart';

sealed class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class onClickDownload extends DownloadEvent {
  final String batch_hash;
  final String file_hash;
  final String didU;

  const onClickDownload(
      {required this.batch_hash, required this.file_hash, required this.didU});
}

class onClickDownloadUrl extends DownloadEvent {
  final String BatchHash;
      final String FileHash;
      final String Odid;
      final String FileName;
      final String Cids;
  


  const onClickDownloadUrl(
      {required this.BatchHash, required this.FileHash, required this.Odid, required this.FileName, required this.Cids});
}

class ResetDownloadStateEvent extends DownloadEvent {
  @override
  List<Object> get props => [];
}



class onDownloadResponse extends DownloadEvent {
  final String? response;
  final String? batchHash;


  const onDownloadResponse(this.response,this.batchHash);
}



final class onGetDownloadStatusEvent extends DownloadEvent {
  final String sessionId;
  final String batch_hash;

  const onGetDownloadStatusEvent(this.sessionId, this.batch_hash);
}

class GetCidsEvent extends DownloadEvent {
  final dynamic index;
  final String did;
  final String owner;
  final String batch_hash;

  const GetCidsEvent( {required this.index,required this.did, required this.owner, required this.batch_hash});
}
