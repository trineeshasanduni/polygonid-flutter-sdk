import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/entities/addPlans_entity.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_status_entity.dart';

abstract class AddPlansRepository{
  Future<Either<Failure,AddPlansEntity>> genetateSecrets();

  Future<Either<Failure,AddPlansEntity>> addUser({required String Commitment,required String Did, required String NullifierHash,required  String Owner});

  Future<Either<Failure,AddPlansEntity>> createProof({required String account,required String txhash});

  Future<Either<Failure,AddPlansEntity>> verifyUser({required List<BigInt> A, required List<List<BigInt>> B, required List<BigInt> C, required List<String> Inputs, required String Owner, required String Did});
  
  
  
}