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
