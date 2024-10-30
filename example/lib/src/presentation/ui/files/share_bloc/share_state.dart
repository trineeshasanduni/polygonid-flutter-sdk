part of 'share_bloc.dart';

sealed class ShareState extends Equatable {
  const ShareState();
  
  @override
  List<Object> get props => [];
}

final class ShareInitial extends ShareState {}

final class Sharing extends ShareState{}

final class Shared extends ShareState {
  final ShareEntity response;
  // final String batchhash;

  const Shared(this.response);
}

final class ShareFailed extends ShareState {
  final String message;

  const ShareFailed(this.message);
}

final class ShareVerifying extends ShareState{
  final String batchhash;
  ShareVerifying(this.batchhash);
}

final class ShareVerifyFailed extends ShareState {
  final String message;

  const ShareVerifyFailed(this.message);
}

final class ShareVerifySuccess extends ShareState {
  final VerifyShareEntity response;
  final String batchhash; 

  const ShareVerifySuccess( this.response,this.batchhash);
}
final class ShareVerifyResponseloaded extends ShareState {
  final Iden3MessageEntity iden3message;
  final String batchhash; 
  

  ShareVerifyResponseloaded(this.iden3message,this.batchhash);
}

final class ShareVerifiedClaims extends ShareState {
  final List<ClaimModel> claimList;
  final String batchhash; 

  ShareVerifiedClaims(this.claimList,this.batchhash);
}
