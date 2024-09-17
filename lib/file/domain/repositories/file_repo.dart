import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/downloadVerify_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/download_status_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/fileName_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/verify_upload_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/register_entity.dart';

abstract class FileRepository {
  Future<Either<Failure, FileEntity>> fileUpload({
    required String did,
    required String ownerDid,
    required File fileData,
  });

  Future<Either<Failure, FileEntity>> useSpace({
    required String did,
    required String ownerDid,
    required int batchSize,
  });

  Future<Either<Failure,FileNameEntity>> getFileName(
    {required String BatchHash}
  );

   Future<Either<Failure,VerifyUploadEntity>> verifyUpload(
    {required String BatchHash,
    required String ownerDid,
    required String did}
  );


  Future<Either<Failure, DownloadVerifyEntity>> downloadVerify({
   required String batch_hash,
      required String file_hash,
      required String didU
  });
  Future<Either<Failure,DownloadStatusResponseentity>> fetchDownloadStatus(
    {required String sessionId}
  );


}
