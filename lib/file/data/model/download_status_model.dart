class DownloadStatusResponseModel {
  final int statusCode;

  DownloadStatusResponseModel({
    required this.statusCode,
  });

  factory DownloadStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return DownloadStatusResponseModel(
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
    };
  }

  
}