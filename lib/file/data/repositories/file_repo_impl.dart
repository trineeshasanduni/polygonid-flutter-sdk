import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/file/data/dataSources/file_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/file/data/model/cid_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/downloadUrl_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/downloadVerify_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/download_status_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/fileName_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/file_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/share_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/verify_upload_model.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/cid_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/downloadUrl_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/downloadVerify_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/download_status_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/fileName_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/share_entity.dart';
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
        fileHash: fileNameModel.fileHash,
      ));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, VerifyUploadEntity>> verifyUpload(
      {required String BatchHash,
      required String ownerDid,
      required String did}) async {
    try {
      final VerifyUploadModel verifyUploadModel = await fileRemoteDatasource
          .verifyUpload(BatchHash: BatchHash, ownerDid: ownerDid, did: did);
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

  ///////////////////////////Download Verify///////////////////////////
  ///
  @override
  Future<Either<Failure, DownloadVerifyEntity>> downloadVerify(
      {required String batch_hash,
      required String file_hash,
      required String didU}) async {
    try {
      DownloadVerifyModel downloadVerifyModel =
          await fileRemoteDatasource.downloadVerify(
              BatchHash: batch_hash, FileHash: file_hash, Odid: didU);
      print('object234: ${downloadVerifyModel.body?.callbackUrl!}');
      return right(DownloadVerifyEntity(
          body: BodyDownloadEntity(
            callbackUrl: downloadVerifyModel.body?.callbackUrl,
            reason: downloadVerifyModel.body?.reason,
            scope: downloadVerifyModel.body?.scope
                ?.map((scope) => Scope(
                      circuitId: scope.circuitId,
                      id: scope.id,
                      query: Query(
                        allowedIssuers: scope.query?.allowedIssuers,
                        context: scope.query?.context,
                        credentialSubject: CredentialSubjectEntity(
                          hash: HashEntity(
                            $eq: scope.query?.credentialSubject?.hash?.$eq,
                          ),
                        ),
                        type: scope.query?.type,
                      ),
                    ))
                .toList(),
          ),
          from: downloadVerifyModel.from,
          id: downloadVerifyModel.id,
          type: downloadVerifyModel.type,
          thid: downloadVerifyModel.thid,
          typ: downloadVerifyModel.typ,
          sessionId: downloadVerifyModel.sessionId));
    } catch (error) {
      return left(Failure('Failed to upload: $error'));
    }
  }

  @override
  Future<Either<Failure, DownloadStatusResponseentity>> fetchDownloadStatus(
      {required String sessionId}) async {
    try {
      final DownloadStatusResponseModel downloadStatusResponseModel =
          await fileRemoteDatasource.fetchDownloadStatus(sessionId);
      return right(DownloadStatusResponseentity(
          statusCode: downloadStatusResponseModel.statusCode));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, CidEntity>> getCids(
      {required dynamic index,
      required String did,
      required String owner,
      required String BatchHash}) async {
    try {
      final CidModel cidModel =
          await fileRemoteDatasource.getCids(index, did, owner, BatchHash);
      return right(CidEntity(
        cids: cidModel.cids,
        batchhash: cidModel.batchhash,
      ));
    } catch (e) {
      return Left(Failure());
    }
  }

  Future<Either<Failure, DownloadUrlEntity>> download(
      {required String BatchHash,
      required String FileHash,
      required String Odid,
      required String FileName,
      required String Cids}) async {
    try {
      DownloadUrlModel downloadModel = await fileRemoteDatasource.download(
          BatchHash: BatchHash,
          FileHash: FileHash,
          Odid: Odid,
          FileName: FileName,
          Cids: Cids);

      return right(DownloadUrlEntity(
        dID: downloadModel.dID,
        uRL: downloadModel.uRL,
      ));
    } catch (error) {
      return left(Failure('Failed to download: $error'));
    }
  }


  /////////////////share/////////////////
  ///
   Future<Either<Failure, ShareEntity>> share(
      {required String BatchHash,
      required String FileHash,
      required String OwnerDid,
      required String FileName,
      required String ShareDid,
      required String Owner}) async {
    try {
      ShareModel shareModel = await fileRemoteDatasource.share(
        BatchHash: BatchHash,
        FileHash:FileHash,
        OwnerDid:OwnerDid,
        ShareDid: ShareDid,
        Owner: Owner,
        FileName: FileName);

      return right(ShareEntity(
        tXHash: shareModel.tXHash,
        ownerDid: shareModel.ownerDid,

        
      ));
    } catch (error) {
      return left(Failure('Failed to share: $error'));
    }
  }
}
