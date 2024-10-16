class ValidateOTPModel {
  String? dID;
  bool? validate;

  ValidateOTPModel({this.dID, this.validate});

  ValidateOTPModel.fromJson(Map<String, dynamic> json) {
    dID = json['DID'];
    validate = json['Validate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DID'] = this.dID;
    data['Validate'] = this.validate;
    return data;
  }
}