import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_status_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/repositories/login_repository.dart';

class LoginDoneUsecase  {
  final LoginRepository loginRepository;

  LoginDoneUsecase(this.loginRepository);

  Future<Either<Failure, LoginEntity>> call() async {
    return await loginRepository.loginsDone();
  }
}

class LoginStatusUsecase {
  final LoginRepository loginRepository;

  LoginStatusUsecase(this.loginRepository);

  Future<Either<Failure, LoginStatusResponseentity>> call(UseCaseParams params) async {



    return await loginRepository.fetchLoginStatus(
      sessionId: params.sessionId
    );
  }
}

class UseCaseParams {
  final String sessionId;

  UseCaseParams({required this.sessionId});
}