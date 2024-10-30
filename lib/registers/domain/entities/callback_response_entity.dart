class CallbackResponseEntity {
  BodyQrEntity? body;
  String? from;
  String? id;
  String? thid;
  String? to;
  String? typ;
  String? type;

  CallbackResponseEntity(
      {this.body, this.from, this.id, this.thid, this.to, this.typ, this.type});

  CallbackResponseEntity.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new BodyQrEntity.fromJson(json['body']) : null;
    from = json['from'];
    id = json['id'];
    thid = json['thid'];
    to = json['to'];
    typ = json['typ'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    data['from'] = this.from;
    data['id'] = this.id;
    data['thid'] = this.thid;
    data['to'] = this.to;
    data['typ'] = this.typ;
    data['type'] = this.type;
    return data;
  }
}

class BodyQrEntity {
  List<CredentialsQrEntity>? credentials;
  String? url;

  BodyQrEntity({this.credentials, this.url});

  BodyQrEntity.fromJson(Map<String, dynamic> json) {
    if (json['credentials'] != null) {
      credentials = <CredentialsQrEntity>[];
      json['credentials'].forEach((v) {
        credentials!.add(new CredentialsQrEntity.fromJson(v));
      });
    }
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.credentials != null) {
      data['credentials'] = this.credentials!.map((v) => v.toJson()).toList();
    }
    data['url'] = this.url;
    return data;
  }
}

class CredentialsQrEntity {
  String? description;
  String? id;

  CredentialsQrEntity({this.description, this.id});

  CredentialsQrEntity.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    return data;
  }
}