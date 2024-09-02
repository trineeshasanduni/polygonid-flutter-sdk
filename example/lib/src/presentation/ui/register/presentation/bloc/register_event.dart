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

final class fetchAndSaveClaims extends RegisterEvent {
  final Iden3MessageEntity iden3message;

  fetchAndSaveClaims({required this.iden3message});
}

final class getClaims extends RegisterEvent{
  final List<FilterEntity>? filters;

  getClaims({this.filters});
}

final class onClickClaim extends RegisterEvent{
  final ClaimModel claimModel;

  onClickClaim(this.claimModel);
}

      
    



