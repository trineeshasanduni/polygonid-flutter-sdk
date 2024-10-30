class DownloadVerifyModel {
  BodyDownload? body;
  String? from;
  String? id;
  String? thid;
  String? typ;
  String? type;
  String? sessionId;

  DownloadVerifyModel(
      {this.body, this.from, this.id, this.thid, this.typ, this.type,this.sessionId});

  DownloadVerifyModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new BodyDownload.fromJson(json['body']) : null;
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

class BodyDownload {
  String? callbackUrl;
  String? reason;
  List<ScopeDownload>? scope;

  BodyDownload({this.callbackUrl, this.reason, this.scope});

  BodyDownload.fromJson(Map<String, dynamic> json) {
    callbackUrl = json['callbackUrl'];
    reason = json['reason'];
    if (json['scope'] != null) {
      scope = <ScopeDownload>[];
      json['scope'].forEach((v) {
        scope!.add(new ScopeDownload.fromJson(v));
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

class ScopeDownload {
  String? circuitId;
  int? id;
  QueryDownload? query;

  ScopeDownload({this.circuitId, this.id, this.query});

  ScopeDownload.fromJson(Map<String, dynamic> json) {
    circuitId = json['circuitId'];
    id = json['id'];
    query = json['query'] != null ? new QueryDownload.fromJson(json['query']) : null;
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

class QueryDownload {
  List<String>? allowedIssuers;
  String? context;
  CredentialSubject? credentialSubject;
  String? type;

  QueryDownload({this.allowedIssuers, this.context, this.credentialSubject, this.type});

  QueryDownload.fromJson(Map<String, dynamic> json) {
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
  Hash? hash;

  CredentialSubject({this.hash});

  CredentialSubject.fromJson(Map<String, dynamic> json) {
    hash = json['hash'] != null ? new Hash.fromJson(json['hash']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hash != null) {
      data['hash'] = this.hash!.toJson();
    }
    return data;
  }
}

class Hash {
  String? $eq;

  Hash({this.$eq});

  Hash.fromJson(Map<String, dynamic> json) {
    $eq = json['\$eq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['\$eq'] = this.$eq;
    return data;
  }
}