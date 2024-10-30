class CidEntity {
  final List<String> cids;
  String? batchhash;
  

  CidEntity({required this.cids, this.batchhash});

  // If you need to parse from JSON to List<String>
  factory CidEntity.fromJson(List<dynamic> json) {
    return CidEntity(
      cids: json.map((item) => item['Cid'].toString()).toList(),
    );
  }
}
