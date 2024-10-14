class ActivityModel {
  List<GroupedLogsModel>? groupedLogs;

  ActivityModel({this.groupedLogs});

  ActivityModel.fromJson(Map<String, dynamic> json) {
    if (json['grouped_logs'] != null) {
      groupedLogs = <GroupedLogsModel>[];
      json['grouped_logs'].forEach((v) {
        groupedLogs!.add(new GroupedLogsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.groupedLogs != null) {
      data['grouped_logs'] = this.groupedLogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupedLogsModel {
  List<LogsModel>? logs;

  GroupedLogsModel({this.logs});

  GroupedLogsModel.fromJson(Map<String, dynamic> json) {
    if (json['logs'] != null) {
      logs = <LogsModel>[];
      json['logs'].forEach((v) {
        logs!.add(new LogsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.logs != null) {
      data['logs'] = this.logs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LogsModel {
  String? id;
  String? name;
  String? data;
  String? did;
  String? level;
  String? traceId;
  TimestampModel? timestamp;
  String? humanReadableTimestamp;

  LogsModel(
      {this.id,
      this.name,
      this.data,
      this.did,
      this.level,
      this.traceId,
      this.timestamp,
      this.humanReadableTimestamp});

  LogsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    data = json['data'];
    did = json['did'];
    level = json['level'];
    traceId = json['trace_id'];
    timestamp = json['timestamp'] != null
        ? new TimestampModel.fromJson(json['timestamp'])
        : null;
    humanReadableTimestamp = json['human_readable_timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['data'] = this.data;
    data['did'] = this.did;
    data['level'] = this.level;
    data['trace_id'] = this.traceId;
    if (this.timestamp != null) {
      data['timestamp'] = this.timestamp!.toJson();
    }
    data['human_readable_timestamp'] = this.humanReadableTimestamp;
    return data;
  }
}

class TimestampModel {
  int? seconds;
  int? nanos;

  TimestampModel({this.seconds, this.nanos});

  TimestampModel.fromJson(Map<String, dynamic> json) {
    seconds = json['seconds'];
    nanos = json['nanos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seconds'] = this.seconds;
    data['nanos'] = this.nanos;
    return data;
  }
}