class FileNameEntity {
  String? fileHash;
  String? fileName;
  String? batchHash;

  FileNameEntity({this.fileHash, this.fileName, this.batchHash});

  FileNameEntity.fromJson(Map<String, dynamic> json) {
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