class Product {
  String? name;
  String? measurement;
  double? price;

  Product({this.name, this.measurement, this.price});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    measurement = json['measurement'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['measurement'] = this.measurement;
    data['price'] = this.price;
    return data;
  }
}
