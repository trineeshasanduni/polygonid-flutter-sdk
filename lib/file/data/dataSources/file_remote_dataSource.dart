import 'dart:convert';
import 'dart:io';
import 'package:polygonid_flutter_sdk/file/data/model/cid_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/downloadUrl_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/downloadVerify_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/downloadZip_Model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/download_status_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/fileName_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/file_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/share_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/verify_share_model.dart';
import 'package:polygonid_flutter_sdk/file/data/model/verify_upload_model.dart';

abstract class FileRemoteDatasource {
  Future<FileModel> fileUpload({
    required String did,
    required String ownerDid,
    required List<File> files,
  });

  Future<FileModel> useSpace({
    required String did,
    required String ownerDid,
    required int batchSize,
  });

  Future<List<FileNameModel>> getFileName(String BatchHash, String Verify);

  Future<VerifyUploadModel> verifyUpload({
    required String BatchHash,
    required String did,
    required String ownerDid,
  });

  Future<DownloadVerifyModel> downloadVerify(
      {required String BatchHash,
      required String FileHash,
      required String Odid});

  Future<DownloadStatusResponseModel> fetchDownloadStatus(String sessionId);

  Future<CidModel> getCids(
      dynamic index, String did, String owner, String BatchHash);

  Future<DownloadUrlModel> download(
      {required String BatchHash,
      required String FileHash,
      required String Odid,
      required String FileName,
      required String Cids});

  Future<DownloadZipModel> downloadZip({
    required String batchHash,
    required String odid,
    required List<BatchData> batchData, // List of BatchData items
  });

  Future<ShareModel> share(
      {required String BatchHash,
      required String FileHash,
      required String OwnerDid,
      required String FileName,
      required String ShareDid,
      required String Owner});

  Future<VerifyShareModel> shareVerifyUpload({
    required String BatchHash,
    required String FileHash,
    required String Did,
    required String OwnerAddress,
  });


  Future<List<CidModel>> getBatchCids(
      {required String Owner,
      required String DID,
      required List<int> Index,
     required String BatchHash});
}

class BatchData {
  final String fileName;
  final String fileHash;
  final String cids;

  BatchData({
    required this.fileName,
    required this.fileHash,
    required this.cids,
  });

  

}



