class RegisterQrEntity {
  String? qR;
  String? aDDQR;
  String? sessionID;

  RegisterQrEntity({this.qR, this.aDDQR, this.sessionID});

  RegisterQrEntity.fromJson(Map<String, dynamic> json) {
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
