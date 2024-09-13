import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/entities/addPlans_entity.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/entities/freeSpace_entity.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/repositories/addPlans_repository.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/common/usecase/usecase.dart';
import 'package:polygonid_flutter_sdk/dashboard/data/dataSources/addUser.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_status_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/repositories/login_repository.dart';

class GenerateSecretsUsecase {
  final AddPlansRepository addPlansRepository;

  GenerateSecretsUsecase(this.addPlansRepository);

  Future<Either<Failure, AddPlansEntity>> call() async {
    print('fetching generateSecrets');
    return await addPlansRepository.genetateSecrets();
  }
}

class AddUserUsecase implements UseCase<AddPlansEntity, UseCaseParams> {
  final AddPlansRepository addPlansRepository;
  const AddUserUsecase(this.addPlansRepository);
  @override
  Future<Either<Failure, AddPlansEntity>> call(UseCaseParams params) async {
    print('registering123: ${params.nullifier}');
    return await addPlansRepository.addUser(
        Commitment: params.commitment,
        Did: params.did,
        NullifierHash: params.nullifier,
        Owner: params.owner);
  }
}
class CreateProofUsecase implements UseCase<AddPlansEntity, CreatProofParams> {
  final AddPlansRepository addPlansRepository;
  const CreateProofUsecase(this.addPlansRepository);
  @override
  Future<Either<Failure, AddPlansEntity>> call(CreatProofParams params) async {
    print('registering12: ${params.txhash}');
    return await addPlansRepository.createProof(
        account: params.account,
        txhash: params.txhash);
        
  }
}

class VerifyUsecase implements UseCase<AddPlansEntity, VerifyParams> {
  final AddPlansRepository addPlansRepository;
  const VerifyUsecase(this.addPlansRepository);
  @override
  Future<Either<Failure, AddPlansEntity>> call(VerifyParams params) async {
    print('registering12: ${params.owner}');
    return await addPlansRepository.verifyUser(
        A: params.a,
        B: params.b,
        C: params.c,
        Inputs: params.input,
        Owner: params.owner,
        Did: params.did);
        
  }
}

class FreeSpaceUsecase implements UseCase<FreeSpaceEntity, FreeSpaceParams> {
  final AddPlansRepository addSpaceRepository;
  const FreeSpaceUsecase(this.addSpaceRepository);
  @override
  Future<Either<Failure, FreeSpaceEntity>> call(FreeSpaceParams params) async {
    print('registering1234: ${params.did}');
    print('registering12341: ${params.owner}');
    return await addSpaceRepository.freeSpace(
        did: params.did,
        owner: params.owner);
  }
}

class FreeSpaceParams{
  
  final String did;
  final String owner;
 

  FreeSpaceParams(
      {required this.did,
      required this.owner,
     
     });
}





class UseCaseParams {
  final String did;
  final String owner;
  final String nullifier;
  final String commitment;

  UseCaseParams(
      {required this.did,
      required this.owner,
      required this.nullifier,
      required this.commitment,
     });
}

class CreatProofParams{
  
  final String account;
  final String txhash;


  CreatProofParams({
    
    required this.account,
    required this.txhash,
  });
}

class VerifyParams{
  
  final List<String> a;
  final List<List<String>> b;
  final List<String> c;
  final List<String> input;
  final String owner;
  final String did;

  VerifyParams({
    required this.a,
    required this.b,
    required this.c,
    required this.input,
    required this.owner,
    required this.did,
  });
}
