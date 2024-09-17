class DownloadStatusResponseentity {
  final int statusCode;
  

  DownloadStatusResponseentity({
    required this.statusCode,
  });

  factory DownloadStatusResponseentity.fromJson(Map<String, dynamic> json) {
    return DownloadStatusResponseentity(
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
    };
  }

  
}