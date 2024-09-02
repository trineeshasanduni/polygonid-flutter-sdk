import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_status_entity.dart';

abstract class LoginRepository{
  Future<Either<Failure,LoginEntity>> loginsDone();
  Future<Either<Failure,LoginStatusResponseentity>> fetchLoginStatus(
    {required String sessionId}
  );
  
}