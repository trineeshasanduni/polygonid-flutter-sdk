class CidModel {
  String cid;
  int queueId;

  CidModel({required this.cid, required this.queueId});

  // Factory method to create a CidModel object from a JSON map
  factory CidModel.fromJson(Map<String, dynamic> json) {
    return CidModel(
      cid: json['Cid'],
      queueId: json['QueueId'],
    );
  }

  // Method to convert a FileData object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'Cid': cid,
      'QueueId': queueId,
    };
  }
}
