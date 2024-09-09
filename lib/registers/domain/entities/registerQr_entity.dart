class RegisterQREntity {
  BodyQR? body;

  RegisterQREntity({this.body});

  RegisterQREntity.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new BodyQR.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class BodyQR {
  String? callbackUrl;

  BodyQR({this.callbackUrl});

  BodyQR.fromJson(Map<String, dynamic> json) {
    callbackUrl = json['callbackUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['callbackUrl'] = this.callbackUrl;
    return data;
  }
}