class VerifyUploadEntity {
  ClaimVerifyEntity? claim;
  String? txHash;

  VerifyUploadEntity({this.claim, this.txHash});

  VerifyUploadEntity.fromJson(Map<String, dynamic> json) {
    claim = json['claim'] != null ? new ClaimVerifyEntity.fromJson(json['claim']) : null;
    txHash = json['txHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.claim != null) {
      data['claim'] = this.claim!.toJson();
    }
    data['txHash'] = this.txHash;
    return data;
  }
}

class ClaimVerifyEntity {
  BodyVerifyEntity? body;
  String? from;
  String? id;
  String? thid;
  String? to;
  String? typ;
  String? type;

  ClaimVerifyEntity(
      {this.body, this.from, this.id, this.thid, this.to, this.typ, this.type});

  ClaimVerifyEntity.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new BodyVerifyEntity.fromJson(json['body']) : null;
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

class BodyVerifyEntity {
  List<CredentialsVerifyEntity>? credentials;
  String? url;

  BodyVerifyEntity({this.credentials, this.url});

  BodyVerifyEntity.fromJson(Map<String, dynamic> json) {
    if (json['credentials'] != null) {
      credentials = <CredentialsVerifyEntity>[];
      json['credentials'].forEach((v) {
        credentials!.add(new CredentialsVerifyEntity.fromJson(v));
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

class CredentialsVerifyEntity {
  String? description;
  String? id;

  CredentialsVerifyEntity({this.description, this.id});

  CredentialsVerifyEntity.fromJson(Map<String, dynamic> json) {
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
