class RegisterQRModel {
  BodyQrModel? body;

  RegisterQRModel({this.body});

  RegisterQRModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new BodyQrModel.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class BodyQrModel {
  String? callbackUrl;

  BodyQrModel({this.callbackUrl});

  BodyQrModel.fromJson(Map<String, dynamic> json) {
    callbackUrl = json['callbackUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['callbackUrl'] = this.callbackUrl;
    return data;
  }
}