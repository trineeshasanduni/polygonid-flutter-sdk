import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/common/usecase/usecase.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/callback_response_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/registerQr_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/register_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/repositories/register_repo.dart';

class RegisterUsecase implements UseCase<RegisterEntity, UseCaseParams> {
  final RegisterRepository registerRepository;
  const RegisterUsecase(this.registerRepository);
  @override
  Future<Either<Failure, RegisterEntity>> call(UseCaseParams params) async {
    print('registering12: ${params.did}');
    return await registerRepository.registerWithDID(
        did: params.did,
        first: params.first,
        last: params.last,
        email: params.email);
  }
}

class CallbackUsecase implements UseCase<CallbackResponseEntity, CallbackParams> {
  final RegisterRepository registerRepository;
  const CallbackUsecase(this.registerRepository);
 
  Future<Either<Failure, CallbackResponseEntity>> call(CallbackParams params) async {
    // print('registering12: ${params.did}');
    return await registerRepository.FetchWithCallbackUrl(
        callbackUrl: params.callbackUrl,
        did: params.did

    );
  }
}



class CallbackParams {
  final String callbackUrl;
  final String did;

  CallbackParams({required this.callbackUrl, required this.did});
}

class UseCaseParams {
  final String did;
  final String first;
  final String last;
  final String email;

  UseCaseParams(
      {required this.did,
      required this.first,
      required this.last,
      required this.email});
}
