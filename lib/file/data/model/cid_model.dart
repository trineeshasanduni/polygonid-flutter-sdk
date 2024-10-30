class CidModel {
  final List<String> cids;
  String? batchhash;

  CidModel({required this.cids, this.batchhash});

  // If you need to parse from JSON to List<String>
  factory CidModel.fromJson(List<dynamic> json) {
    return CidModel(
      cids: json.map((item) => item['Cid'].toString()).toList(),

    );
  }
}
