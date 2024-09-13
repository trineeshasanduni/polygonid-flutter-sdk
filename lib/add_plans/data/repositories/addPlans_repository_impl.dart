import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/add_plans/data/dataSources/remote/addPlans_remote_datasource_impl.dart';
import 'package:polygonid_flutter_sdk/add_plans/data/model/addPlans_model.dart';
import 'package:polygonid_flutter_sdk/add_plans/data/model/freeSpace_model.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/entities/addPlans_entity.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/entities/freeSpace_entity.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/repositories/addPlans_repository.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
// import 'package:polygonid_flutter_sdk/login/data/dataSources/login_remote_datasource.dart';
import 'package:polygonid_flutter_sdk/login/data/dataSources/remote/login_remote_datasource_impl.dart';
import 'package:polygonid_flutter_sdk/login/data/model/login_modal.dart';
import 'package:polygonid_flutter_sdk/login/data/model/login_status_model.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_status_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/repositories/login_repository.dart';

class AddplansRepositoryImpl implements AddPlansRepository {
  final AddPlansRemoteDatasource addPlansRemoteDatasource;

  AddplansRepositoryImpl({required this.addPlansRemoteDatasource});

  @override
  Future<Either<Failure, AddPlansEntity>> genetateSecrets() async {
    print('fetch2');
    try {
      final AddPlansModel addPlansModel =
          await addPlansRemoteDatasource.genetateSecrets();
      return right(AddPlansEntity(
          
          commitment: addPlansModel.commitment,
          nullifierHash: addPlansModel.nullifierHash,
          
          
      ));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, AddPlansEntity>> addUser(
      {required String Commitment,
      required String Did,
      required String NullifierHash,
      required String Owner}) async {
    try {
      final AddPlansModel addPlansModel =
          await addPlansRemoteDatasource.addUser(
        Did: Did,
        Owner: Owner,
        NullifierHash: NullifierHash,
        Commitment: Commitment,
      );

      return right(AddPlansEntity(
        TXHash: addPlansModel.TXHash,
      ));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, AddPlansEntity>> createProof(
      {required String account, required String txhash}) async {
    try {
      final AddPlansModel addPlansModel =
          await addPlansRemoteDatasource.createProof(
        account: account,
        txhash: txhash,
      );

      return right(AddPlansEntity(
        a: addPlansModel.a,
        b: addPlansModel.b,
        c: addPlansModel.c,
        input: addPlansModel.input,
        
      ));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, AddPlansEntity>> verifyUser(
    {required List<String> A, required List<List<String>> B, required List<String> C, required List<String> Inputs, required String Owner, required String Did}) async {
    try {
      final AddPlansModel addPlansModel =
          await addPlansRemoteDatasource.verifyUser(
        A: A,
        B: B,
        C: C,
        Inputs: Inputs,
        Owner: Owner,
        Did: Did,
        
      );

      return right(AddPlansEntity(
        TXHash: addPlansModel.TXHash,
        
      ));
    } catch (e) {
      return Left(Failure());
    }
  }

    @override
  Future<Either<Failure, FreeSpaceEntity>> freeSpace(
      {required String did, required String owner}) async {
    try {
      final FreeSpaceModel addSpaceModel =
          await addPlansRemoteDatasource.freeSpace(
        did: did,
        owner: owner,
      );

      return right(FreeSpaceEntity(
        TXHash : addSpaceModel.TXHash,
      ));
    } catch (e) {
      return Left(Failure());
    }
  }

 
}
