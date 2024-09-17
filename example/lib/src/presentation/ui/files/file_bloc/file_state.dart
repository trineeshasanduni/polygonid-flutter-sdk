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

final class Fileverifying extends FileState {}

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

  VerifyResponseloaded(this.iden3message);
}

final class VerifySuccess extends FileState {
  final VerifyUploadEntity response;

  const VerifySuccess( this.response);
}



final class VerifiedClaims extends FileState {
  final List<ClaimModel> claimList;

  VerifiedClaims(this.claimList);
}






