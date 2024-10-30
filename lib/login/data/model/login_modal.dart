class LoginModal {
  Body? body;
  String? from;
  String? id;
  String? thid;
  String? typ;
  String? type;
  String? headers;

  LoginModal({this.body, this.from, this.id, this.thid, this.typ, this.type, this.headers});

  LoginModal.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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

class Body {
  String? callbackUrl;
  String? reason;
  List<Scope>? scope;

  Body({this.callbackUrl, this.reason, this.scope});

  Body.fromJson(Map<String, dynamic> json) {
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
  CredentialSubject? credentialSubject;
  String? type;

  Query({this.allowedIssuers, this.context, this.credentialSubject, this.type});

  Query.fromJson(Map<String, dynamic> json) {
    allowedIssuers = json['allowedIssuers'].cast<String>();
    context = json['context'];
    credentialSubject = json['credentialSubject'] != null
        ? new CredentialSubject.fromJson(json['credentialSubject'])
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

class CredentialSubject {
  Auth? auth;

  CredentialSubject({this.auth});

  CredentialSubject.fromJson(Map<String, dynamic> json) {
    auth = json['auth'] != null ? new Auth.fromJson(json['auth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.auth != null) {
      data['auth'] = this.auth!.toJson();
    }
    return data;
  }
}

class Auth {
  String? $eq;

  Auth({this.$eq});

  Auth.fromJson(Map<String, dynamic> json) {
    $eq = json['\$eq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['\$eq'] = this.$eq;
    return data;
  }
}