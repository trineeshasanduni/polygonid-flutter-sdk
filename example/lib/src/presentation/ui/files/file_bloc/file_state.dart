part of 'file_bloc.dart';

sealed class FileState extends Equatable {
  const FileState();
  
  @override
  List<Object> get props => [];
}

final class FileInitial extends FileState {}

final class FileUploading extends FileState {}

final class FileUploaded extends FileState {
  final FileEntity response;

  const FileUploaded(this.response);
}

final class FileUsingSpaced extends FileState {
  final FileEntity txHash;

  const FileUsingSpaced(this.txHash);
}

final class FileUploadFailed extends FileState {
  final String message;

  const FileUploadFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class FileNameFetchedFailed extends FileState {
  final String message;

  const FileNameFetchedFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class FileNameLoaded extends FileState {
  final FileNameEntity fileName;

  const FileNameLoaded(this.fileName);
}

final class UploadVerified extends FileState {
  final VerifyUploadEntity verifyTxHash;

  const UploadVerified(this.verifyTxHash);
}

class Fileverifying extends FileState {
  final String batchhash;
  Fileverifying(this.batchhash);
}
final class FileVerifyFailed extends FileState {
  final String message;

  const FileVerifyFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class FileVerifySuccess extends FileState {
  final String message;

  const FileVerifySuccess(this.message);

  @override
  List<Object> get props => [message];
}
final class FileVerifyResponseSuccess extends FileState {
  final String message;

  const FileVerifyResponseSuccess(this.message);

  @override
  List<Object> get props => [message];
}
final class VerifyResponseloaded extends FileState {
  final Iden3MessageEntity iden3message;
  final String batchhash; 
  

  VerifyResponseloaded(this.iden3message,this.batchhash);
}

final class VerifySuccess extends FileState {
  final VerifyUploadEntity response;
  final String batchhash; 

  const VerifySuccess( this.response,this.batchhash);
}



final class VerifiedClaims extends FileState {
  final List<ClaimModel> claimList;
  final String batchhash; 

  VerifiedClaims(this.claimList,this.batchhash);
}






