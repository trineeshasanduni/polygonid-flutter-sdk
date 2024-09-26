part of 'share_bloc.dart';

sealed class ShareEvent extends Equatable {
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class onClickShare extends ShareEvent {
  final String batch_hash;
  final String file_hash;
  final String OwnerDid;
  final String ShareDid;
  final String Owner;
  final String FileName;

  const onClickShare(
      {required this.batch_hash, required this.file_hash, required this.OwnerDid,required this.FileName, required this.Owner, required this.ShareDid});
}
