class LoginEntity {
  BodyEntity? body;
  String? from;
  String? id;
  String? thid;
  String? typ;
  String? type;
  String? headers;

  LoginEntity({this.body, this.from, this.id, this.thid, this.typ, this.type, this.headers});

  LoginEntity.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new BodyEntity.fromJson(json['body']) : null;
    from = json['from'];
    id = json['id'];
    thid = json['thid'];
    typ = json['typ'];
    type = json['type'];
    headers = json['headers'];
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
    data['headers'] = this.headers;
    return data;
  }
}

class BodyEntity {
  String? callbackUrl;
  String? reason;
  List<ScopeEntity>? scope;

  BodyEntity({this.callbackUrl, this.reason, this.scope});

  BodyEntity.fromJson(Map<String, dynamic> json) {
    callbackUrl = json['callbackUrl'];
    reason = json['reason'];
    if (json['scope'] != null) {
      scope = <ScopeEntity>[];
      json['scope'].forEach((v) {
        scope!.add(new ScopeEntity.fromJson(v));
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

class ScopeEntity {
  String? circuitId;
  int? id;
  QueryEntity? query;

  ScopeEntity({this.circuitId, this.id, this.query});

  ScopeEntity.fromJson(Map<String, dynamic> json) {
    circuitId = json['circuitId'];
    id = json['id'];
    query = json['query'] != null ? new QueryEntity.fromJson(json['query']) : null;
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

class QueryEntity {
  List<String>? allowedIssuers;
  String? context;
  CredentialSubjectEntity? credentialSubject;
  String? type;

  QueryEntity({this.allowedIssuers, this.context, this.credentialSubject, this.type});

  QueryEntity.fromJson(Map<String, dynamic> json) {
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
  AuthEntity? auth;

  CredentialSubjectEntity({this.auth});

  CredentialSubjectEntity.fromJson(Map<String, dynamic> json) {
    auth = json['auth'] != null ? new AuthEntity.fromJson(json['auth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.auth != null) {
      data['auth'] = this.auth!.toJson();
    }
    return data;
  }
}

class AuthEntity {
  String? $eq;

  AuthEntity({this.$eq});

  AuthEntity.fromJson(Map<String, dynamic> json) {
    // Accessing the "$eq" key from the JSON
    $eq = json['\$eq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // Setting the "$eq" key in the JSON
    data['\$eq'] = this.$eq;
    return data;
  }
}