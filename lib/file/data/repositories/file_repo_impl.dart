import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/file/data/dataSources/file_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/file/data/model/fileName_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/file_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/verify_upload_model.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/fileName_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/verify_upload_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/repositories/file_repo.dart';
import 'package:polygonid_flutter_sdk/registers/data/dataSources/register_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/registers/data/model/register_model.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/register_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/repositories/register_repo.dart';

class FileRepoImpl implements FileRepository {
  final FileRemoteDatasource fileRemoteDatasource;

  FileRepoImpl({required this.fileRemoteDatasource});

  @override
  Future<Either<Failure, FileEntity>> fileUpload({
    required String did,
    required String ownerDid,
    required File fileData,
  }) async {
    try {
      FileModel fileModel = await fileRemoteDatasource.fileUpload(
        did: did,
        ownerDid: ownerDid,
        fileData: fileData,
      );
      // print('object234: ${registerModel.body?.credentials![0].description}');
      return right(FileEntity(
        TXHash: fileModel.TXHash,
        Did: fileModel.Did,
        FileCount: fileModel.FileCount,
      ));
    } catch (error) {
      return left(Failure('Failed to upload: $error'));
    }
  }

  @override
  Future<Either<Failure, FileEntity>> useSpace(
      {required String did,
      required String ownerDid,
      required int batchSize}) async {
    try {
      FileModel fileModel = await fileRemoteDatasource.useSpace(
        did: did,
        ownerDid: ownerDid,
        batchSize: batchSize,
      );
      return right(FileEntity(
        TXHash: fileModel.TXHash,
      ));
    } catch (error) {
      return left(Failure('Failed to upload: $error'));
    }
  }

  @override
  Future<Either<Failure, FileNameEntity>> getFileName(
      {required String BatchHash}) async {
    try {
      final FileNameModel fileNameModel =
          await fileRemoteDatasource.getFileName(BatchHash);
      return right(FileNameEntity(
         fileName: fileNameModel.fileName,
         batchHash: fileNameModel.batchHash,

      ));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, VerifyUploadEntity>> verifyUpload(
      {required String BatchHash, required String ownerDid , required String did }) async {
    try {
      final VerifyUploadModel verifyUploadModel =
          await fileRemoteDatasource.verifyUpload(BatchHash: BatchHash, ownerDid : ownerDid, did: did);
      return right(VerifyUploadEntity(
        claim: ClaimVerifyEntity(
              body: BodyVerifyEntity(
                credentials: [
                  CredentialsVerifyEntity(
                    description:
                        verifyUploadModel.claim?.body?.credentials![0].description,
                    id: verifyUploadModel.claim?.body?.credentials![0].id,
                  ),
                ],
                url: verifyUploadModel.claim?.body?.url,
              ),
              from: verifyUploadModel.claim?.from,
              id: verifyUploadModel.claim?.id,
              thid: verifyUploadModel.claim?.thid,
              to: verifyUploadModel.claim?.to,
              typ: verifyUploadModel.claim?.typ,
              type: verifyUploadModel.claim?.type,
            ),
            txHash: verifyUploadModel.txHash,
        
        
         
      ));
    } catch (e) {
      return Left(Failure());
    }
  }
}
