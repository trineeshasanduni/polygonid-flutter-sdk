import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/registers/data/dataSources/register_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/registers/data/model/callbackResponse_model.dart';
import 'package:polygonid_flutter_sdk/registers/data/model/registerQr_model.dart';
import 'package:polygonid_flutter_sdk/registers/data/model/register_model.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/callback_response_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/registerQr_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/register_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/repositories/register_repo.dart';

class RegisterRepoImpl implements RegisterRepository {
  final RegisterRemoteDatasource registerRemoteDatasource;

  RegisterRepoImpl({required this.registerRemoteDatasource});

  @override
  Future<Either<Failure, RegisterEntity>> registerWithDID({
    required String did,
    required String first,
    required String last,
    required String email,
  }) async {
    try {
      RegisterModel registerModel =
          await registerRemoteDatasource.registerWithDID(
        did: did,
        first: first,
        last: last,
        email: email,
      );
      print('object234: ${registerModel.body?.credentials![0].description}');
      return right(RegisterEntity(
        body: BodyEntity(
          credentials: [
            CredentialsEntity(
              description: registerModel.body?.credentials![0].description,
              id: registerModel.body?.credentials![0].id,
            ),
          ],
          url: registerModel.body?.url,
        ),
        from: registerModel.from,
        id: registerModel.id,
        type: registerModel.type,
        thid: registerModel.thid,
        to: registerModel.to,
        typ: registerModel.typ,
        statusCode: registerModel.statusCode,
      ));
    } catch (error) {
      return left(Failure('Failed to register: $error'));
    }
  }

  @override
  Future<Either<Failure, CallbackResponseEntity>> FetchWithCallbackUrl(
      {required String callbackUrl, required String did}) async {
    try {
      CallbackResponseModel callbackResponseModel =
          (await registerRemoteDatasource.FetchWithCallbackUrl(
        callbackUrl: callbackUrl,
        did: did,
      ));
      return right(CallbackResponseEntity(
        body: BodyQrEntity(
          credentials: [
            CredentialsQrEntity(
              description:
                  callbackResponseModel.body?.credentials![0].description,
              id: callbackResponseModel.body?.credentials![0].id,
            ),
          ],
          url: callbackResponseModel.body?.url,
        ),
        from: callbackResponseModel.from,
        id: callbackResponseModel.id,
        thid: callbackResponseModel.thid,
        to: callbackResponseModel.to,
        typ: callbackResponseModel.typ,
        type: callbackResponseModel.type,
      ));
    } catch (error) {
      return left(Failure('Failed to fetch callback: $error'));
    }
  }

  // @override
  // Future<Either<Failure, RegisterQREntity>> FetchWithCallbackUrl( String ) async{
  //   try {
  //     RegisterQRModel registerQrModel = await registerRemoteDatasource.FetchWithCallbackUrl(
  //       did: callbackUrl,
  //     );
  //     return right(RegisterQREntity(
  //       body: BodyQR(
  //         callbackUrl: registerQrModel.body?.callbackUrl,
  //       ),

  //     ));
  //   } catch (error) {
  //     return left(Failure('Failed to register: $error'));
  //   }

  // }
}
