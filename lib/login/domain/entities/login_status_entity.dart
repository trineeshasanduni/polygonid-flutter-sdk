class LoginStatusResponseentity {
  final int statusCode;
  final String did;

  LoginStatusResponseentity({
    required this.statusCode,
    required this.did,
  });

  factory LoginStatusResponseentity.fromJson(Map<String, dynamic> json) {
    return LoginStatusResponseentity(
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