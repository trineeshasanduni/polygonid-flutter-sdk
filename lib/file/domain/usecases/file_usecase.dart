import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/common/usecase/usecase.dart';
import 'package:polygonid_flutter_sdk/file/data/model/download_status_model.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/cid_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/downloadUrl_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/downloadVerify_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/download_status_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/fileName_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/share_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/verify_upload_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/repositories/file_repo.dart';

class UseCaseParams {
  final String did;
  final String ownerDid;
  final File?
      fileData; // Made optional since it might not be needed in every use case.
  // Made optional since it might not be needed in every use case.

  UseCaseParams({
    required this.did,
    required this.ownerDid,
    required this.fileData,
  });
}

class DownloadUrlParams {
  final String BatchHash;
  final String FileHash;
  final String FileName;
  final String Odid;
  final String Cids;

  DownloadUrlParams(
      {required this.BatchHash,
      required this.FileHash,
      required this.Odid,
      required this.FileName,
      required this.Cids});
}

class ShareUrlParams {
  final String BatchHash;
  final String FileHash;
  final String FileName;
  final String OwnerDid;
  final String ShareDid;
  final String Owner;

  ShareUrlParams(
      {required this.BatchHash,
      required this.FileHash,
      required this.OwnerDid,
      required this.FileName,
      required this.ShareDid,
      required this.Owner});
}

class DownloadParams {
  final String batch_hash;
  final String file_hash;
  final String didU;

  DownloadParams(
      {required this.batch_hash, required this.file_hash, required this.didU});
}

class UseSpaceParam {
  final String did;
  final String ownerDid;

  final int? batchSize;

  UseSpaceParam({
    required this.did,
    required this.ownerDid,
    required this.batchSize,
  });
}

class FileNameParam {
  final String BatchHash;
  final String Verify;

  FileNameParam({
    required this.BatchHash,
    required this.Verify,
  });
}

class CidsParams {
  final String index;
  final String did;
  final String owner;
  final String BatchHash;

  CidsParams({
    required this.index,
    required this.did,
    required this.owner,
    required this.BatchHash,
  });
}

class VerifyUploadParam {
  final String BatchHash;
  final String ownerDid;
  final String did;

  VerifyUploadParam({
    required this.BatchHash,
    required this.ownerDid,
    required this.did,
  });
}

class DownloadStatusParams {
  final String sessionId;

  DownloadStatusParams({required this.sessionId});
}

// Modify both UseCase implementations to use UseCaseParams:

class FileUsecase implements UseCase<FileEntity, UseCaseParams> {
  final FileRepository fileRepository;
  const FileUsecase(this.fileRepository);

  @override
  Future<Either<Failure, FileEntity>> call(UseCaseParams params) async {
    print('registering12: ${params.did}');
    return await fileRepository.fileUpload(
      did: params.did,
      ownerDid: params.ownerDid,
      fileData: params.fileData!,
    );
  }
}

class UseSpaceUsecase implements UseCase<FileEntity, UseSpaceParam> {
  final FileRepository fileRepository;
  const UseSpaceUsecase(this.fileRepository);

  @override
  Future<Either<Failure, FileEntity>> call(UseSpaceParam params) async {
    print('registering1235: ${params.did}');
    return await fileRepository.useSpace(
      did: params.did,
      ownerDid: params.ownerDid,
      batchSize: params.batchSize!,
    );
  }
}

class FileNameUsecase {
  final FileRepository fileRepository;

  FileNameUsecase(this.fileRepository);

  Future<Either<Failure, FileNameEntity>> call(FileNameParam params) async {
    print('fetching file name');

    return await fileRepository.getFileName(BatchHash: params.BatchHash,Verify: params.Verify);
  }
}

class VerifyUploadUsecase {
  final FileRepository fileRepository;

  VerifyUploadUsecase(this.fileRepository);

  Future<Either<Failure, VerifyUploadEntity>> call(
      VerifyUploadParam params) async {
    print('fetching file name');

    return await fileRepository.verifyUpload(
      BatchHash: params.BatchHash,
      ownerDid: params.ownerDid,
      did: params.did,
    );
  }
}

/////////////////////////download verify ////////////////////
///
///
@override
class DownloadVerifyUsecase
    implements UseCase<DownloadVerifyEntity, DownloadParams> {
  final FileRepository fileRepository;
  const DownloadVerifyUsecase(this.fileRepository);

  @override
  Future<Either<Failure, DownloadVerifyEntity>> call(
      DownloadParams params) async {
    // print('registering12: ${params.did}');
    return await fileRepository.downloadVerify(
        batch_hash: params.batch_hash,
        file_hash: params.file_hash,
        didU: params.didU);
  }
}

@override
class DownloadStatusUsecase {
  final FileRepository fileRepository;

  DownloadStatusUsecase(this.fileRepository);

  Future<Either<Failure, DownloadStatusResponseentity>> call(
      DownloadStatusParams params) async {
    return await fileRepository.fetchDownloadStatus(
        sessionId: params.sessionId);
  }
}

@override
class CidsUsecase {
  final FileRepository fileRepository;

  CidsUsecase(this.fileRepository);

  Future<Either<Failure, CidEntity>> call(CidsParams params) async {
    print('fetching cids');

    return await fileRepository.getCids(
        index: params.index, did: params.did, owner: params.owner, BatchHash: params.BatchHash);
  }
}

@override
class DownloadUsecase
    implements UseCase<DownloadUrlEntity, DownloadUrlParams> {
      
  final FileRepository fileRepository;
  const DownloadUsecase(this.fileRepository);

  @override
  Future<Either<Failure, DownloadUrlEntity>> call(
      DownloadUrlParams params) async {
    // print('registering12: ${params.did}');
    return await fileRepository.download(
        BatchHash: params.BatchHash,
        FileHash: params.FileHash,
        Odid: params.Odid,
        FileName: params.FileName,
        Cids: params.Cids);
        
  }
}


////////////////////////share//////////////////
///
@override
class ShareUsecase
    implements UseCase<ShareEntity, ShareUrlParams> {
      
  final FileRepository fileRepository;
  const ShareUsecase(this.fileRepository);

  @override
  Future<Either<Failure, ShareEntity>> call(
      ShareUrlParams params) async {
    // print('registering12: ${params.did}');
    return await fileRepository.share(
      BatchHash: params.BatchHash,
        FileHash: params.FileHash,
        OwnerDid: params.OwnerDid,
        FileName: params.FileName,
        ShareDid: params.ShareDid,
        Owner: params.Owner
      
        );
        
  }
}
