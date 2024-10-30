class GetEmailEntity {
  bool? isVerified;
  String? userEmail;

  GetEmailEntity({this.isVerified, this.userEmail});

  GetEmailEntity.fromJson(Map<String, dynamic> json) {
    isVerified = json['is_verified'];
    userEmail = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_verified'] = this.isVerified;
    data['user_email'] = this.userEmail;
    return data;
  }
}