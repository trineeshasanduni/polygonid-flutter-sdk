class ActivityEntity {
  List<GroupedLogs>? groupedLogs;

  ActivityEntity({this.groupedLogs});

  ActivityEntity.fromJson(Map<String, dynamic> json) {
    if (json['grouped_logs'] != null) {
      groupedLogs = <GroupedLogs>[];
      json['grouped_logs'].forEach((v) {
        groupedLogs!.add(new GroupedLogs.fromJson(v));
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

class GroupedLogs {
  List<Logs>? logs;

  GroupedLogs({this.logs});

  GroupedLogs.fromJson(Map<String, dynamic> json) {
    if (json['logs'] != null) {
      logs = <Logs>[];
      json['logs'].forEach((v) {
        logs!.add(new Logs.fromJson(v));
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

class Logs {
  String? id;
  String? name;
  String? data;
  String? did;
  String? level;
  String? traceId;
  Timestamp? timestamp;
  String? humanReadableTimestamp;

  Logs(
      {this.id,
      this.name,
      this.data,
      this.did,
      this.level,
      this.traceId,
      this.timestamp,
      this.humanReadableTimestamp});

  Logs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    data = json['data'];
    did = json['did'];
    level = json['level'];
    traceId = json['trace_id'];
    timestamp = json['timestamp'] != null
        ? new Timestamp.fromJson(json['timestamp'])
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

class Timestamp {
  int? seconds;
  int? nanos;

  Timestamp({this.seconds, this.nanos});

  Timestamp.fromJson(Map<String, dynamic> json) {
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