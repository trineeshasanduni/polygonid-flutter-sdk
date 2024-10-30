part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithCredentials extends LoginEvent {}

class clickScanQrCode extends LoginEvent {
  const clickScanQrCode();
}

class onLoginResponse extends LoginEvent {
  final String? response;

  const onLoginResponse(this.response);
}

class onLoginStatus extends LoginEvent {
  final Int did;

  const onLoginStatus(this.did);
}

class onGetStatusEvent extends LoginEvent {
  final String sessionId;

  const onGetStatusEvent(this.sessionId);
}


