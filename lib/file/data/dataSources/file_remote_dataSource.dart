import 'dart:io';
import 'package:polygonid_flutter_sdk/file/data/model/fileName_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/file_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/verify_upload_model.dart';

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

  Future<VerifyUploadModel> verifyUpload(
      {required String BatchHash,
        required String did,
      required String ownerDid,
      
      }
  );

 
}