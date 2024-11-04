part of 'file_bloc.dart';

sealed class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

class FileuploadEvent extends FileEvent {
  final String did;
  final String ownerDid;
  final List<File> fileData;
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
  final String Verify;
  const GetFileNameEvent( {required this.BatchHash,required this.Verify});
}

class GetFileNameOnlyEvent extends FileEvent {
  final String BatchHash;
  const GetFileNameOnlyEvent( {required this.BatchHash});
}

class VerifyUploadEvent extends FileEvent {
  final String BatchHash;
  final String ownerDid;
  final String did;
  final String FileHash;
  const VerifyUploadEvent( {required this.BatchHash,required this.ownerDid, required this.did,required this.FileHash});
}

class onVerifyResponse extends FileEvent {
  final String? verifyResponse;
  final String? batchHash;
    final String? fileHash;


  const onVerifyResponse(this.verifyResponse,this.batchHash,this.fileHash);
}

final class fetchAndSaveUploadVerifyClaims extends FileEvent {
  final Iden3MessageEntity iden3message;
  final String? batchHash;
  final String? fileHash;

  const fetchAndSaveUploadVerifyClaims({required this.iden3message,required this.batchHash,required this.fileHash});
}

class ResetFileStateEvent extends FileEvent {
  @override
  List<Object> get props => [];
}


final class getUploadVerifyClaims extends FileEvent {
  final List<FilterEntity>? filters;
  final String? batchHash;
  final String? fileHash;


  getUploadVerifyClaims(this.batchHash,this.fileHash, {this.filters});
}





