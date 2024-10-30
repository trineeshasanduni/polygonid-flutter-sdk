class DownloadVerifyEntity {
  BodyDownloadEntity? body;
  String? from;
  String? id;
  String? thid;
  String? typ;
  String? type;
  String? sessionId;

  DownloadVerifyEntity(
      {this.body, this.from, this.id, this.thid, this.typ, this.type,this.sessionId});

  DownloadVerifyEntity.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new BodyDownloadEntity.fromJson(json['body']) : null;
    from = json['from'];
    id = json['id'];
    thid = json['thid'];
    typ = json['typ'];
    type = json['type'];
    sessionId= json['sessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    data['from'] = this.from;
    data['id'] = this.id;
    data['thid'] = this.thid;
    data['typ'] = this.typ;
    data['type'] = this.type;
    data['sessionId'] = this.sessionId;
    return data;
  }
}

class BodyDownloadEntity {
  String? callbackUrl;
  String? reason;
  List<Scope>? scope;

  BodyDownloadEntity({this.callbackUrl, this.reason, this.scope});

  BodyDownloadEntity.fromJson(Map<String, dynamic> json) {
    callbackUrl = json['callbackUrl'];
    reason = json['reason'];
    if (json['scope'] != null) {
      scope = <Scope>[];
      json['scope'].forEach((v) {
        scope!.add(new Scope.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['callbackUrl'] = this.callbackUrl;
    data['reason'] = this.reason;
    if (this.scope != null) {
      data['scope'] = this.scope!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Scope {
  String? circuitId;
  int? id;
  Query? query;

  Scope({this.circuitId, this.id, this.query});

  Scope.fromJson(Map<String, dynamic> json) {
    circuitId = json['circuitId'];
    id = json['id'];
    query = json['query'] != null ? new Query.fromJson(json['query']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['circuitId'] = this.circuitId;
    data['id'] = this.id;
    if (this.query != null) {
      data['query'] = this.query!.toJson();
    }
    return data;
  }
}

class Query {
  List<String>? allowedIssuers;
  String? context;
  CredentialSubjectEntity? credentialSubject;
  String? type;

  Query({this.allowedIssuers, this.context, this.credentialSubject, this.type});

  Query.fromJson(Map<String, dynamic> json) {
    allowedIssuers = json['allowedIssuers'].cast<String>();
    context = json['context'];
    credentialSubject = json['credentialSubject'] != null
        ? new CredentialSubjectEntity.fromJson(json['credentialSubject'])
        : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allowedIssuers'] = this.allowedIssuers;
    data['context'] = this.context;
    if (this.credentialSubject != null) {
      data['credentialSubject'] = this.credentialSubject!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class CredentialSubjectEntity {
  HashEntity? hash;

  CredentialSubjectEntity({this.hash});

  CredentialSubjectEntity.fromJson(Map<String, dynamic> json) {
    hash = json['hash'] != null ? new HashEntity.fromJson(json['hash']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hash != null) {
      data['hash'] = this.hash!.toJson();
    }
    return data;
  }
}

class HashEntity {
  String? $eq;

  HashEntity({this.$eq});

  HashEntity.fromJson(Map<String, dynamic> json) {
    $eq = json['\$eq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['\$eq'] = this.$eq;
    return data;
  }
}