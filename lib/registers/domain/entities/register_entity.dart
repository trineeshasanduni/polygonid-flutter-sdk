class RegisterEntity {
  BodyEntity? body;
  String? from;
  String? id;
  String? thid;
  String? to;
  String? typ;
  String? type;

  RegisterEntity(
      {this.body, this.from, this.id, this.thid, this.to, this.typ, this.type});

  RegisterEntity.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? BodyEntity.fromJson(json['body']) : null;
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

class BodyEntity {
  List<CredentialsEntity>? credentials;
  String? url;

  BodyEntity({this.credentials, this.url});

  BodyEntity.fromJson(Map<String, dynamic> json) {
    if (json['credentials'] != null) {
      credentials = <CredentialsEntity>[];
      json['credentials'].forEach((v) {
        credentials!.add(new CredentialsEntity.fromJson(v));
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

class CredentialsEntity {
  String? description;
  String? id;

  CredentialsEntity({this.description, this.id});

  CredentialsEntity.fromJson(Map<String, dynamic> json) {
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