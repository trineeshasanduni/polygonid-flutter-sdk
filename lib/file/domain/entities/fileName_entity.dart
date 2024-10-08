class FileNameEntity {
  String? fileHash;
  String? fileName;
  String? batchHash;
  bool? isVerified;

  FileNameEntity({this.fileHash, this.fileName, this.batchHash,this.isVerified});

  FileNameEntity.fromJson(Map<String, dynamic> json) {
    fileHash = json['FileHash'];
    fileName = json['FileName'];
    batchHash = json['BatchHash'];
    isVerified = json['IsVerified'];
  }

 

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileHash'] = this.fileHash;
    data['FileName'] = this.fileName;
    data['BatchHash']= this.batchHash;
    data['IsVerified'] = this.isVerified;
    return data;
  }
}