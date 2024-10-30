class NetworkUsageEntity {
  String? day;
  int? dailyUsage;

  NetworkUsageEntity({this.day, this.dailyUsage});

  factory NetworkUsageEntity.fromJson(Map<String, dynamic> json) {
    return NetworkUsageEntity(
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
