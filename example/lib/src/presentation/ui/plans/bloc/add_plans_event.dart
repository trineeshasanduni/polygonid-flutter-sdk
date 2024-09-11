part of 'add_plans_bloc.dart';

sealed class AddPlansEvent extends Equatable {
  const AddPlansEvent();

  @override
  List<Object> get props => [];
}

final class GenerateSecretsEvent extends AddPlansEvent {
  const GenerateSecretsEvent();
}

final class addUserEvent extends AddPlansEvent {
  final String did;
  final String owner;
  final String nullifier;
  final String commitment;

  addUserEvent({
    required this.did,
    required this.owner,
    required this.nullifier,
    required this.commitment,
  });
}

final class createProofEvent extends AddPlansEvent {
  final String txhash;
  final String owner;
  

  createProofEvent({
    required this.txhash,
    required this.owner,
    
  });
}

final class verifyuserEvent extends AddPlansEvent {
  final List<BigInt> A;
  final List<List<BigInt>> B;
  final List<BigInt> C;
  final List<String> Inputs;
  final String Owner;
  final String Did;

  verifyuserEvent({
    required this.A,
    required this.B,
    required this.C,
    required this.Inputs,
    required this.Owner,
    required this.Did,
  });
}

final class freeSpaceEvent extends AddPlansEvent {
  final String did;
  final String owner;

  const freeSpaceEvent( {
    required this.did,
    required this.owner,
  });
}


