part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {
  final String message;

  const LoginLoading(this.message);
}

final class LoginSuccess extends LoginState {
  final LoginEntity response;

  const LoginSuccess( this.response);
}

final class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class navigateToQrCodeScanner extends LoginState {
  const navigateToQrCodeScanner();
}

final class loaded extends LoginState {
  final Iden3MessageEntity iden3message;

  loaded(this.iden3message);
}

  final class authenticated extends LoginState {
    const authenticated();
  }

  final class StatusLoaded extends LoginState {
    final LoginStatusResponseentity did;

    StatusLoaded(this.did);
  }

      



