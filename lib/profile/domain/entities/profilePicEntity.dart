class ProfilePicEntity {
  String? ownerDid;
  String? profileImage;
  String? traceId;

  ProfilePicEntity({this.ownerDid, this.profileImage, this.traceId});

  ProfilePicEntity.fromJson(Map<String, dynamic> json) {
    ownerDid = json['OwnerDid'];
    profileImage = json['ProfileImage'];
    traceId = json['TraceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OwnerDid'] = this.ownerDid;
    data['ProfileImage'] = this.profileImage;
    data['TraceId'] = this.traceId;
    return data;
  }
}