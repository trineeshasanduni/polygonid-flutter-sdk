class PriceModel {
  double? price;

  PriceModel({this.price});

  PriceModel.fromJson(Map<String, dynamic> json) {
    price = json['Price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Price'] = this.price;
    return data;
  }
}