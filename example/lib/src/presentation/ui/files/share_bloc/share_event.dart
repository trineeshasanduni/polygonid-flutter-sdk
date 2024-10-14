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

class ResetShareStateEvent extends ShareEvent {
  @override
  List<Object> get props => [];
}

class ShareVerifyEvent extends ShareEvent {
  final String BatchHash;
  final String FileHash;
  final String Did;
  final String OwnerAddress;
  const ShareVerifyEvent( {required this.BatchHash,required this.FileHash,required this.Did,required this.OwnerAddress});
}

class onShareVerifyResponse extends ShareEvent {
  final String? verifyResponse;
  final String? batchHash;

  const onShareVerifyResponse(this.verifyResponse,this.batchHash);
}

final class fetchAndSaveShareVerifyClaims extends ShareEvent {
  final Iden3MessageEntity iden3message;
  final String? batchHash;

  const fetchAndSaveShareVerifyClaims({required this.iden3message,required this.batchHash});
}
class ResetFileStateEvent extends ShareEvent {
  @override
  List<Object> get props => [];
}


final class getShareVerifyClaims extends ShareEvent {
  final List<FilterEntity>? filters;
  final String? batchHash;

  getShareVerifyClaims(this.batchHash, {this.filters});
}


