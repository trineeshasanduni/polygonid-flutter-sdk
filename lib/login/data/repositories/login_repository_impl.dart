import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
// import 'package:polygonid_flutter_sdk/login/data/dataSources/login_remote_datasource.dart';
import 'package:polygonid_flutter_sdk/login/data/dataSources/remote/login_remote_datasource_impl.dart';
import 'package:polygonid_flutter_sdk/login/data/model/login_modal.dart';
import 'package:polygonid_flutter_sdk/login/data/model/login_status_model.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_status_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDatasource loginRemoteDatasource;

  LoginRepositoryImpl({required this.loginRemoteDatasource});

  @override
  Future<Either<Failure, LoginEntity>> loginsDone() async {
    try {
      final LoginModal loginModal = await loginRemoteDatasource.loginDone();
      return right(LoginEntity(
          body: BodyEntity(
            callbackUrl: loginModal.body?.callbackUrl,
            reason: loginModal.body?.reason,
            scope: loginModal.body?.scope
                ?.map((scope) => ScopeEntity(
                      circuitId: scope.circuitId,
                      id: scope.id,
                      query: QueryEntity(
                        allowedIssuers: scope.query?.allowedIssuers,
                        context: scope.query?.context,
                        credentialSubject: CredentialSubjectEntity(
                          auth: AuthEntity(
                            $eq: scope.query?.credentialSubject?.auth?.$eq,
                          ),
                        ),
                        type: scope.query?.type,
                      ),
                    ))
                .toList(),
          ),
          from: loginModal.from,
          id: loginModal.id,
          type: loginModal.type,
          thid: loginModal.thid,
          typ: loginModal.typ,
          headers: loginModal.headers));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, LoginStatusResponseentity>> fetchLoginStatus(
      {required String sessionId}) async {
    try {
      final LoginStatusResponseModel loginStatusModel =
          await loginRemoteDatasource.fetchLoginStatus(sessionId);
      return right(LoginStatusResponseentity(
          did: loginStatusModel.did, statusCode: loginStatusModel.statusCode));
    } catch (e) {
      return Left(Failure());
    }
  }
}


  
  // @override
  // Future<Either<Failure, LoginEntity>> loginsDone() async{
  //   try {
  //     // Fetch data from remote data source
  //    final LoginModal loginModal = await loginRemoteDatasource.loginDone();

  //     // Map the LoginModal to LoginEntity
  //     final loginEntity = LoginEntity(
  //       body: BodyEntity(
  //         callbackUrl: loginModal.body?.callbackUrl,
  //         reason: loginModal.body?.reason,
  //         scope: loginModal.body?.scope?.map((scope) => ScopeEntity(
  //           circuitId: scope.circuitId,
  //           id: scope.id,
  //           query: QueryEntity(
  //             allowedIssuers: scope.query?.allowedIssuers,
  //             context: scope.query?.context,
  //             credentialSubject: CredentialSubjectEntity(
  //               auth: AuthEntity(
  //                 eq: scope.query?.credentialSubject?.auth?.eq,
  //               ),
  //             ),
  //           ),
  //         )).toList(),
  //       ),
  //       from: loginModal.from,
  //       id: loginModal.id,
  //       type: loginModal.type,
  //       thid: loginModal.thid,
  //       typ: loginModal.typ,
  //     );

  //     // Return the mapped entity wrapped in Right
  //     return right(loginEntity);
  //   } catch (e) {
  //     // Log the error for debugging purposes
  //     print('Error in loginDone: $e');

  //     // Return a Failure wrapped in Left
  //     return Left(Failure());  // Use a specific Failure class like ServerFailure
  //   }
  // }
