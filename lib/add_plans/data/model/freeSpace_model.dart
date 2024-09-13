class FreeSpaceModel {
  String? dID;
  String? owner;
  String? TXHash;

  FreeSpaceModel({this.dID, this.owner, this.TXHash});

  FreeSpaceModel.fromJson(Map<String, dynamic> json) {
    dID = json['DID'];
    owner = json['Owner'];
    TXHash = json['TXHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DID'] = this.dID;
    data['Owner'] = this.owner;
    data['TXHash'] = this.TXHash;
    return data;
  }
}