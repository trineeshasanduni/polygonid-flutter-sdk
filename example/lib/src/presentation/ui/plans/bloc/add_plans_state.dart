part of 'add_plans_bloc.dart';

sealed class AddPlansState extends Equatable {
  const AddPlansState();
  
  @override
  List<Object> get props => [];
}

final class AddPlansInitial extends AddPlansState {}

final class AddPlansLoading extends AddPlansState {}
final class PriceLoading extends AddPlansState {
  final String message;

  PriceLoading(this.message);
}

final class GenerateSecretsSuccess extends AddPlansState {
  final AddPlansEntity response;

  GenerateSecretsSuccess(this.response);
}

final class AddUserSuccess extends AddPlansState {
  final AddPlansEntity addUserResponse;

  AddUserSuccess(this.addUserResponse);
}

final class CreateProof extends AddPlansState {
  final AddPlansEntity ProofResponse;

  CreateProof(this.ProofResponse);
}

final class VerifyProof extends AddPlansState {
  final AddPlansEntity VerifyResponse;

  VerifyProof(this.VerifyResponse);
}


final class AddPlansFailure extends AddPlansState {
  final String error;

  AddPlansFailure(this.error);
}

final class PlanPriceFailure extends AddPlansState {
  final String error;

  PlanPriceFailure(this.error);
}

final class FreeSpaceAdded extends AddPlansState {
  final FreeSpaceEntity freeSpaceResponse;

  FreeSpaceAdded(this.freeSpaceResponse);
}

final class PriceUpdated extends AddPlansState {
  final PriceEntity priceResponse;

  PriceUpdated(this.priceResponse);
}


