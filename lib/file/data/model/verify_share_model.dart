class VerifyShareModel {
  Body? body;
  String? from;
  String? id;
  String? thid;
  String? to;
  String? typ;
  String? type;

  VerifyShareModel(
      {this.body, this.from, this.id, this.thid, this.to, this.typ, this.type});

  VerifyShareModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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

class Body {
  List<Credentials>? credentials;
  String? url;

  Body({this.credentials, this.url});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['credentials'] != null) {
      credentials = <Credentials>[];
      json['credentials'].forEach((v) {
        credentials!.add(new Credentials.fromJson(v));
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

class Credentials {
  String? description;
  String? id;

  Credentials({this.description, this.id});

  Credentials.fromJson(Map<String, dynamic> json) {
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