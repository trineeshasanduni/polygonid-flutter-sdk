import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/callback_response_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/registerQr_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/register_entity.dart';

abstract class RegisterRepository {
  Future<Either<Failure, RegisterEntity>> registerWithDID({
    required String did,
    required String first,
    required String last,
    required String email
  });

  Future<Either<Failure, CallbackResponseEntity>> FetchWithCallbackUrl({
    required String callbackUrl,
    required String did
  });
}
