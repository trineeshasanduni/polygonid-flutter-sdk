import 'dart:io';
import 'package:polygonid_flutter_sdk/file/data/model/fileName_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/file_model.dart';

abstract class FileRemoteDatasource {

  Future<FileModel> fileUpload(
      {required String did,
      required String ownerDid,
      required File fileData,
      }
  );

  Future<FileModel> useSpace(
      {required String did,
      required String ownerDid,
      required int batchSize,
      }
  );

  Future<FileNameModel> getFileName(String BatchHash);

 
}