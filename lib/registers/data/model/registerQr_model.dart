class RegisterQrModel {
  String? qR;
  String? aDDQR;
  String? sessionID;

  RegisterQrModel({this.qR, this.aDDQR, this.sessionID});

  RegisterQrModel.fromJson(Map<String, dynamic> json) {
    qR = json['QR'];
    aDDQR = json['ADDQR'];
    sessionID = json['SessionID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QR'] = this.qR;
    data['ADDQR'] = this.aDDQR;
    data['SessionID'] = this.sessionID;
    return data;
  }
}
