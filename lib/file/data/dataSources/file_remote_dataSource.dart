import 'dart:io';
import 'package:polygonid_flutter_sdk/file/data/model/file_entity.dart';

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

 
}