class GetEmailModel {
  bool? isVerified;
  String? userEmail;

  GetEmailModel({this.isVerified, this.userEmail});

  GetEmailModel.fromJson(Map<String, dynamic> json) {
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