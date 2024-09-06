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


