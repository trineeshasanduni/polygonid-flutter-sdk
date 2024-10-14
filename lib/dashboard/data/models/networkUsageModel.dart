class NetworkUsageModel {
  String? day;
  int? dailyUsage;

  NetworkUsageModel({this.day, this.dailyUsage});

  factory NetworkUsageModel.fromJson(Map<String, dynamic> json) {
    return NetworkUsageModel(
      day: json['day'] as String?,
      dailyUsage: json['daily_usage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'daily_usage': dailyUsage,
    };
  }
}
