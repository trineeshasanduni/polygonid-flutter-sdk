class CidEntity {
  String cid;
  int queueId;

  CidEntity({required this.cid, required this.queueId});

  // Factory method to create a CidEntity object from a JSON map
  factory CidEntity.fromJson(Map<String, dynamic> json) {
    return CidEntity(
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
