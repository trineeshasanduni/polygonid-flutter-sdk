class verifyEmailEntity {
  VerifyEmailsEntity? verifyEmail;

  verifyEmailEntity({this.verifyEmail});

  verifyEmailEntity.fromJson(Map<String, dynamic> json) {
    verifyEmail = json['VerifyEmail'] != null
        ? new VerifyEmailsEntity.fromJson(json['VerifyEmail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.verifyEmail != null) {
      data['VerifyEmail'] = this.verifyEmail!.toJson();
    }
    return data;
  }
}

class VerifyEmailsEntity {
  int? id;
  String? did;
  String? userEmail;
  String? token;
  bool? isVerified;
  String? createdAt;

  VerifyEmailsEntity(
      {this.id,
      this.did,
      this.userEmail,
      this.token,
      this.isVerified,
      this.createdAt});

  VerifyEmailsEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    did = json['did'];
    userEmail = json['user_email'];
    token = json['token'];
    isVerified = json['is_verified'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['did'] = this.did;
    data['user_email'] = this.userEmail;
    data['token'] = this.token;
    data['is_verified'] = this.isVerified;
    data['created_at'] = this.createdAt;
    return data;
  }
}