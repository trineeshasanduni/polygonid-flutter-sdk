class FileNameModel {
  String? fileHash;
  String? fileName;
  String? batchHash;

  FileNameModel({this.fileHash, this.fileName, this.batchHash});

  FileNameModel.fromJson(Map<String, dynamic> json) {
    fileHash = json['FileHash'];
    fileName = json['FileName'];
    batchHash = json['BatchHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileHash'] = this.fileHash;
    data['FileName'] = this.fileName;
    data['BatchHash']= this.batchHash;
    return data;
  }
}