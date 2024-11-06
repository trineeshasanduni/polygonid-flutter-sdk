class DownloadZipEntity {
  String? dID;
  String? uRL;

  DownloadZipEntity({this.dID, this.uRL});

  DownloadZipEntity.fromJson(Map<String, dynamic> json) {
    dID = json['DID'];
    uRL = json['URL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DID'] = this.dID;
    data['URL'] = this.uRL;
    return data;
  }
}