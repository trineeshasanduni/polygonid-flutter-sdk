import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/common/usecase/usecase.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/repositories/file_repo.dart';

class UseCaseParams {
  final String did;
  final String ownerDid;
  final File? fileData;  // Made optional since it might not be needed in every use case.
  final int? batchSize;  // Made optional since it might not be needed in every use case.

  UseCaseParams({
    required this.did,
    required this.ownerDid,
    this.fileData,
    this.batchSize,
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

class UseSpaceUsecase implements UseCase<FileEntity, UseCaseParams> {
  final FileRepository fileRepository;
  const UseSpaceUsecase(this.fileRepository);

  @override
  Future<Either<Failure, FileEntity>> call(UseCaseParams params) async {
    print('registering12: ${params.did}');
    return await fileRepository.useSpace(
      did: params.did,
      ownerDid: params.ownerDid,
      batchSize: params.batchSize!,
    );
  }
}
