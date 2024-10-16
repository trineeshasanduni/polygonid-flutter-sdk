class VerifyTelModel {
  String? oTP;

  VerifyTelModel({this.oTP});

  VerifyTelModel.fromJson(Map<String, dynamic> json) {
    oTP = json['OTP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OTP'] = this.oTP;
    return data;
  }
}