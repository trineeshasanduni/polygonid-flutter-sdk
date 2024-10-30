class DownloadUrlModel {
  String? dID;
  String? uRL;

  DownloadUrlModel({this.dID, this.uRL});

  DownloadUrlModel.fromJson(Map<String, dynamic> json) {
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