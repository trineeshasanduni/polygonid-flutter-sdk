class LoginStatusResponseModel {
  final int statusCode;
  final String did;

  LoginStatusResponseModel({
    required this.statusCode,
    required this.did,
  });

  factory LoginStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginStatusResponseModel(
      statusCode: json['statusCode'],
      did: json['did'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'did': did,
    };
  }

  
}