part of 'add_plans_bloc.dart';

sealed class AddPlansState extends Equatable {
  const AddPlansState();
  
  @override
  List<Object> get props => [];
}

final class AddPlansInitial extends AddPlansState {}

final class AddPlansLoading extends AddPlansState {
  final String message;

  AddPlansLoading(this.message);
}
final class PriceLoading extends AddPlansState {
  final int month;
  final String plan;
  final String message;

  PriceLoading(this.message,this.month,this.plan);
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
   final int month;
  final String plan;

  PlanPriceFailure(this.error,this.month,this.plan);
}

final class FreeSpaceAdded extends AddPlansState {
  final FreeSpaceEntity freeSpaceResponse;

  FreeSpaceAdded(this.freeSpaceResponse);
}

final class PriceUpdated extends AddPlansState {
  final PriceEntity priceResponse;
   final int month;
  final String plan;

  PriceUpdated(this.priceResponse,this.month,this.plan);
}

final class PaidPlanActivated extends AddPlansState {
  final FreeSpaceEntity paidPlanResponse;

  PaidPlanActivated(this.paidPlanResponse);
}


