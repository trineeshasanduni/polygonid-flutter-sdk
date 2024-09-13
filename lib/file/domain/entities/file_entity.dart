class FileEntity {
  String? Did;
  String? TXHash;
  int? FileCount;


  FileEntity({this.Did, this.TXHash, this.FileCount});

  FileEntity.fromJson(Map<String, dynamic> json) {
    Did = json['Did'];
    TXHash = json['TXHash'];
    FileCount = json['FileCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Did'] = this.Did;
    data['TXHash'] = this.TXHash;
    data['FileCount'] = this.FileCount;
    return data;
  }
}
