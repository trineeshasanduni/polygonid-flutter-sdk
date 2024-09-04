import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/repositories/file_repo.dart';

import '../../../common/usecase/usecase.dart';

class FileUsecase implements UseCase<FileEntity, UseCaseParams> {
  final FileRepository fileRepository;
  const FileUsecase(this.fileRepository);
  @override
  Future<Either<Failure, FileEntity>> call(UseCaseParams params) async {
    print('registering12: ${params.did}');
    return await fileRepository.fileUpload( 
        did: params.did, ownerDid: params.ownerDid, fileData: params.fileData);
           
  } 
  
}

class UseCaseParams {
  final String did;
  final String ownerDid;
  final File fileData;
  
  

  UseCaseParams(
      {required this.did,required this.ownerDid,required this.fileData});
}