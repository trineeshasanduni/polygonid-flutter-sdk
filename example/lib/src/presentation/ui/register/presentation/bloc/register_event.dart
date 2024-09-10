part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class SubmitSignup extends RegisterEvent {
  final String did;
  final String first;
  final String last;
  final String email;

  SubmitSignup({
    required this.did,
    required this.first,
    required this.last,
    required this.email,
  });
}

final class onGetRegisterResponse extends RegisterEvent {
  final String? response;

  onGetRegisterResponse(this.response);
}

final class onGetQrResponse extends RegisterEvent {
  final String? response;

  onGetQrResponse(this.response);
}

final class fetchAndSaveClaims extends RegisterEvent {
  final Iden3MessageEntity iden3message;

  fetchAndSaveClaims({required this.iden3message});
}

final class fetchAndSaveQrClaims extends RegisterEvent {
  final Iden3MessageEntity iden3message;

  fetchAndSaveQrClaims({required this.iden3message});
}

final class getClaims extends RegisterEvent {
  final List<FilterEntity>? filters;

  getClaims({this.filters});
}

final class getQrClaims extends RegisterEvent {
  final List<FilterEntity>? filters;

  getQrClaims({this.filters});
}

final class onClickClaim extends RegisterEvent {
  final ClaimModel claimModel;

  onClickClaim(this.claimModel);
}

final class clickScanQrCode extends RegisterEvent {}

final class OnScanQrCodeResponse extends RegisterEvent {
  final String? response;

  OnScanQrCodeResponse(this.response);
}

final class getCallbackUrl extends RegisterEvent {
  final String url;
  final String did;

  getCallbackUrl(this.url, this.did);
}

final class OnCallbackUrlResponse extends RegisterEvent {
  final String? response;

  OnCallbackUrlResponse(this.response);
}
