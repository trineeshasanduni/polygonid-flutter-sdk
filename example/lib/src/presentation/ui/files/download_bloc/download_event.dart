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



class onDownloadResponse extends DownloadEvent {
  final String? response;

  const onDownloadResponse(this.response);
}



final class onGetDownloadStatusEvent extends DownloadEvent {
  final String sessionId;

  const onGetDownloadStatusEvent(this.sessionId);
}
