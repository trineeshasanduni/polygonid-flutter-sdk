
import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/common/usecase/usecase.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/register_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/repositories/register_repo.dart';

class RegisterUsecase implements UseCase<RegisterEntity, UseCaseParams> {
  final RegisterRepository registerRepository;
  const RegisterUsecase(this.registerRepository);
  @override
  Future<Either<Failure, RegisterEntity>> call(UseCaseParams params) async {
    print('registering12: ${params.did}');
    return await registerRepository.registerWithDID( 
        did: params.did, first: params.first, last: params.last, email: params.email);
        
        
  }

  
  
}

class UseCaseParams {
  final String did;
  final String first;
  final String last;
  final String email;
  

  UseCaseParams(
      {required this.did,required this.first,required this.last,required this.email});
}

