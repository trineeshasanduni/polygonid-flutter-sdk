import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
import 'package:polygonid_flutter_sdk/file/data/dataSources/file_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/file/data/model/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
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
        tXHash: fileModel.tXHash,
        did: fileModel.did,
        fileCount: fileModel.fileCount,
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
        tXHash: fileModel.tXHash,
      ));
    } catch (error) {
      return left(Failure('Failed to upload: $error'));
    }
  }
}
