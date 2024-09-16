import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/common/usecase/usecase.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/fileName_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/verify_upload_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/repositories/file_repo.dart';

class UseCaseParams {
  final String did;
  final String ownerDid;
  final File? fileData;  // Made optional since it might not be needed in every use case.
  // Made optional since it might not be needed in every use case.

  UseCaseParams({
    required this.did,
    required this.ownerDid,
   required this.fileData,
    
  });
}

class UseSpaceParam {
  final String did;
  final String ownerDid;
   // Made optional since it might not be needed in every use case.
  final int? batchSize;  // Made optional since it might not be needed in every use case.

  UseSpaceParam({
    required this.did,
    required this.ownerDid,
  
    required this.batchSize,
  });
}

class FileNameParam {
  final String BatchHash;

  FileNameParam({
    required this.BatchHash,
  });
} 

class VerifyUploadParam {
  final String BatchHash;
  final String ownerDid;
  final String did;

  VerifyUploadParam ({
    required this.BatchHash,
    required this.ownerDid,
    required this.did,
  });
  
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

  Future<Either<Failure, FileNameEntity>> call(
    
      FileNameParam params) async {
          print('fetching file name');

    return await fileRepository.getFileName(BatchHash: params.BatchHash);
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
