part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterQrLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final RegisterEntity response;

  RegisterSuccess(this.response);
}

final class Registered extends RegisterState {
  final Iden3MessageEntity iden3message;

  Registered(this.iden3message);
}

final class QrRegistered extends RegisterState {
  final Iden3MessageEntity iden3message;

  QrRegistered(this.iden3message);
}

final class loadedClaims extends RegisterState {
  final List<ClaimModel> claimList;

  loadedClaims(this.claimList);
}

final class loadedQrClaims extends RegisterState {
  final List<ClaimModel> claimList;

  loadedQrClaims(this.claimList);
}

final class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure(this.error);
}

final class NavigateToQrCodeScanner extends RegisterState {}

final class QrCodeScanned extends RegisterState {
  final RegisterQrEntity registerQREntity;

  QrCodeScanned(this.registerQREntity);
}

final class CallbackLoaded extends RegisterState {
  final CallbackResponseEntity callbackResponse;

  CallbackLoaded(this.callbackResponse);
}
