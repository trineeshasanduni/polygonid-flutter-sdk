part of 'file_bloc.dart';

sealed class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

class FileuploadEvent extends FileEvent {
  final String did;
  final String ownerDid;
  final File fileData;
  const FileuploadEvent( {required this.did,required this.ownerDid, required this.fileData});
}

class UseSpaceEvent extends FileEvent {
  final String did;
  final String ownerDid;
  final int batchSize;
  const UseSpaceEvent( {required this.did,required this.ownerDid, required this.batchSize});
}

class GetFileNameEvent extends FileEvent {
  final String BatchHash;
  const GetFileNameEvent( {required this.BatchHash});
}

class VerifyUploadEvent extends FileEvent {
  final String BatchHash;
  final String ownerDid;
  final String did;
  const VerifyUploadEvent( {required this.BatchHash,required this.ownerDid, required this.did});
}

class onVerifyResponse extends FileEvent {
  final String? verifyResponse;

  const onVerifyResponse(this.verifyResponse);
}

final class fetchAndSaveUploadVerifyClaims extends FileEvent {
  final Iden3MessageEntity iden3message;

  fetchAndSaveUploadVerifyClaims({required this.iden3message});
}

final class getUploadVerifyClaims extends FileEvent {
  final List<FilterEntity>? filters;

  getUploadVerifyClaims({this.filters});
}


