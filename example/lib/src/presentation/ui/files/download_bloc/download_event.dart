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
  final String fileHash;
  const onClickDownload(
      {required this.batch_hash,
      required this.file_hash,
      required this.didU,
      required this.fileHash});
}

class onClickDownloadUrl extends DownloadEvent {
  final String BatchHash;
  final String FileHash;
  final String fileHash;
  final String Odid;
  final String FileName;
  final String Cids;

  const onClickDownloadUrl(
      {required this.BatchHash,
      required this.FileHash,
      required this.fileHash,
      required this.Odid,
      required this.FileName,
      required this.Cids});
}

class onClickDownloadZip extends DownloadEvent {
  final String BatchHash;
  final String filehash;

  final String Odid;
  final List<BatchData> batchData;

  const onClickDownloadZip(
      {required this.BatchHash, required this.Odid, required this.batchData,required this.filehash});
}

class ResetDownloadStateEvent extends DownloadEvent {
  @override
  List<Object> get props => [];
}

class onDownloadResponse extends DownloadEvent {
  final String? response;
  final String? batchHash;
  final String? fileHash;

  const onDownloadResponse(this.response, this.batchHash, this.fileHash);
}

final class onGetDownloadStatusEvent extends DownloadEvent {
  final String sessionId;
  final String batch_hash;
  final String fileHash;

  const onGetDownloadStatusEvent(
      this.sessionId, this.batch_hash, this.fileHash);
}

class GetCidsEvent extends DownloadEvent {
  final dynamic index;
  final String did;
  final String owner;
  final String batch_hash;
  final String fileHash;

  const GetCidsEvent(
      {required this.index,
      required this.did,
      required this.owner,
      required this.batch_hash,
      required this.fileHash});
}

class GetBatchCidsEvent extends DownloadEvent {
  final dynamic index;
  final String did;
  final String owner;
  final String batch_hash;
  final String fileHash;

  const GetBatchCidsEvent(
      {required this.index,
      required this.did,
      required this.owner,
      required this.batch_hash,
      required this.fileHash});
}
