class ShareEntity {
  String? ownerDid;
  String? tXHash;

  ShareEntity({this.ownerDid, this.tXHash});

  ShareEntity.fromJson(Map<String, dynamic> json) {
    ownerDid = json['Owner_did'];
    tXHash = json['TXHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Owner_did'] = this.ownerDid;
    data['TXHash'] = this.tXHash;
    return data;
  }
}