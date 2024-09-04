class FileModel {
  String? did;
  String? tXHash;
  int? fileCount;

  FileModel({this.did, this.tXHash, this.fileCount});

  FileModel.fromJson(Map<String, dynamic> json) {
    did = json['Did'];
    tXHash = json['TXHash'];
    fileCount = json['FileCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Did'] = this.did;
    data['TXHash'] = this.tXHash;
    data['FileCount'] = this.fileCount;
    return data;
  }
}
