class FileNameModel {
  String? fileHash;
  String? fileName;

  FileNameModel({this.fileHash, this.fileName});

  FileNameModel.fromJson(Map<String, dynamic> json) {
    fileHash = json['FileHash'];
    fileName = json['FileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileHash'] = this.fileHash;
    data['FileName'] = this.fileName;
    return data;
  }
}