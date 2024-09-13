class AddPlansEntity {
  String? commitment;
  String? nullifierHash;
  String? txhash;
  String? TXHash;
  List<String>? A; // A, B, C might be lists instead of single String
  List<String>? B;
  List<String>? C;
  List<String>? a;
  List<List<String>>? b;
  List<String>? c;
  List<String>? input; // Assuming input is a list of strings now
  String? account;

  AddPlansEntity({
    this.commitment,
    this.nullifierHash,
    this.txhash,
    this.A,
    this.B,
    this.C,
    this.a,
    this.b,
    this.c,
    this.input,
    this.TXHash,
    this.account,
  });

  // Parsing from JSON
  AddPlansEntity.fromJson(Map<String, dynamic> json) {
    commitment = json['commitment'];
    nullifierHash = json['nullifierHash'];
    txhash = json['txhash'];

    // Checking if A, B, C, etc., are lists and parsing them accordingly
    A = (json['A'] as List<dynamic>?)
        ?.map((e) => e.toString()) 
        .toList();
    B = (json['B'] as List<dynamic>?)
        ?.map((e) => e.toString()) 
        .toList();
    C = (json['C'] as List<dynamic>?)
        ?.map((e) => e.toString()) 
        .toList();

    a = (json['a'] as List<dynamic>?)
        ?.map((e) => e.toString()) 
        .toList();
   
    b = (json['b'] as List<dynamic>?)
        ?.map((list) => (list as List<dynamic>)
            .map((item) => item.toString()) 
            .toList())
        .toList();
    c = (json['c'] as List<dynamic>?)
        ?.map((e) => e.toString()) 
        .toList();

    input = (json['input'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(); // Input as list of strings

    TXHash = json['TXHash'];
    account = json['account'];
  }

  // Converting to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commitment'] = this.commitment;
    data['nullifierHash'] = this.nullifierHash;
    data['txhash'] = this.txhash;
    
    // Convert lists to JSON format
    data['A'] = this.A?.map((e) => e.toString()).toList();
    data['B'] = this.B?.map((e) => e.toString()).toList();
    data['C'] = this.C?.map((e) => e.toString()).toList();

    data['a'] = this.a?.map((e) => e.toString()).toList();
   data['b'] = this.b?.map((list) => list.map((item) => item.toString()).toList()).toList();
    data['c'] = this.c?.map((e) => e.toString()).toList();

    data['input'] = this.input;

    data['TXHash'] = this.TXHash;
    data['account'] = this.account;

    return data;
  }
}
